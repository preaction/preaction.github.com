#ifndef SHARED_SV_INCLUDE
#define SHARED_SV_INCLUDE

/**
 * A dumb pointer that also contains a Perl SV* that wraps the pointer,
 * creating a smart pointer.
 *
 * This class is useful when you need to have the SV in C++ later, for a
 * callback in a threaded application, for example. This class is meant to
 * be held inside of an STL container or another object to help avoid
 * memory leaks that are caused by improper use of dumb pointers.
 *
 * The Perl SV* is considered the owner of the pointer, so this class will
 * never free the data pointed to, it will only decrement the SV* reference
 * count so that Perl can free the data if it wants to. This allows the Perl
 * programmer to use the SV* even after the shared_sv instance goes away.
 *
 * If you need to keep a SV* inside C++ code (to perform callbacks, for
 * example), you should create a shared_sv inside XS and return a new SV by
 * calling ref() instead. Don't return a weak_ref() from an XSUB with an SV*
 * return type.
 *
 * Ex:
 *
 *      std::vector<shared_sv<MyClass> > instances;
 *
 *      SV*
 *      new( CLASS )
 *          char* CLASS
 *          CODE:
 *              shared_sv<MyClass> ssv( new MyClass(), CLASS );
 *              instances.push_back( ssv ); // We need the SV in C++ later...
 *              RETVAL = ssv.ref();
 *              // XS calls sv_2mortal on XSUBs that return SV*
 */

#include <iostream>
#include "perl.h"

template< typename T >
class shared_sv {
    /**
     * The pointer our SV contains. This is here for convenience, it is also possible to 
     * get this exact pointer out of the sv_.
     *
     * This is a dumb pointer managed by Perl's SV ref counting. This class encapsulates
     * this reference counting for C++'s use-cases.
     */
    T* p_;
    /**
     * A reference to the SV containing our pointer. This SV holds all the
     * responsibility for the p_ pointer. There must be a DESTROY() XSUB that
     * properly frees the pointer inside or you will leak
     */
    SV* sv_;
    public:
        /**
         * Create a new, blank shared_sv. No Perl SV is created. This is required for 
         * STL container classes.
         */
        shared_sv()
            : p_(0), sv_(0)
        {};

        /**
         * Create a new SV with the given pointer. The SV is blessed into the given
         * class.
         */
        shared_sv( T* p, std::string package )
            : p_(p), sv_( newSV(0) ) // SV created with refcnt 1
        {
            if ( sv_ == 0 ) return;
            sv_ = sv_setref_pv( sv_, package.c_str(), p_ );
            // std::cout << "SharedSV with pointer " << p_ << " SV: " << sv_ << " REF: " << SvREFCNT( sv_ ) 
                // << std::endl;
        }

        /**
         * Copy constructor. Increments refcount.
         */
        shared_sv( const shared_sv<T>& that )
            : p_(that.p_), sv_(that.sv_)
        {
            // We can inc the refcount faster if we don't care about return value (void)
            if ( sv_ == 0 ) return;
            SvREFCNT_inc_void( sv_ );
            // std::cout << "SV " << sv_ << " ++ " << SvREFCNT( sv_ ) << std::endl;
        }

        /**
         * A casting copy constructor, increments refcount. Uses a static_cast
         * on the pointer
         */
        template< typename Y > shared_sv( const shared_sv<Y>& that ) 
            : p_(static_cast<T*>(that.get())), sv_(that.sv())
        { 
            if ( sv_ == 0 ) return;
            SvREFCNT_inc_void( sv_ );
            // std::cout << "SV " << sv_ << " ++ " << SvREFCNT( sv_ ) <<
            // std::endl;
        }

        /**
         * Assignment operator will decrement old refcount and increment new refcount
         */
        shared_sv<T>& operator=( const shared_sv<T>& that )
        {
            if ( this == &that ) return *this;
            p_ = static_cast<T*>(that.get());
            if ( sv_ != 0 ) {
                // std::cout << "SV " << sv_ << " -- " << SvREFCNT( sv_ ) << std::endl;
                SvREFCNT_dec( sv_ );
            }
            sv_ = that.sv();
            if ( sv_ == 0 ) return *this;
            SvREFCNT_inc_void( sv_ );
            // std::cout << "SV " << sv_ << " ++ " << SvREFCNT( sv_ ) << std::endl;
            return *this;
        }

        /**
         * Destructor should dec our SV*. Perl will free our pointer
         * by calling the SV's DESTROY() XS function if the SV* ref count is 0.
         *
         * We do not do any delete here in case someone in the Perl side has a
         * reference. We want them to be able to use that reference.
         */
        ~shared_sv() {
            if ( sv_ == 0 ) return;
            SvREFCNT_dec( sv_ );
            // std::cout << "SV " << sv_ << " -- " << SvREFCNT( sv_ ) << std::endl;
        }

        /**
         * Get the SV. If you plan on giving the SV back to Perl, use ref() or
         * weak_ref() instead.
         */
        SV* sv() const {
            return sv_;
        }

        /**
         * Get the object pointer.
         */
        T* get() const {
            return p_;
        }

        /**
         * Get the object pointer
         */
        T* operator->() const {
            return get();
        }

        /**
         * Create a new reference to the underlying SV and return it,
         * incrementing this SV's ref count. The SV returned has a ref count of
         * 1.
         */
        SV* ref() const {
            return newRV( SvRV(sv_) );
        }

        /**
         * Create a new reference to the underlying SV and return it without
         * incrementing the SV's ref count.
         *
         * This is good for when you still want the SV stored here to be
         * cleaned up even if this object (or the reference returned from
         * weak_ref()) is still around.
         *
         * Do not use this if returning the SV from an XSUB with a return type
         * of SV*. Perl automatically calls sv_2mortal on RETVAL for you, and
         * you will get a warning: "Attempt to free unreferenced scalar".
         */
        SV* weak_ref() const {
            return newRV_noinc( SvRV(sv_) );
        }
};
#endif

