/** @file
    File:       IccArrayFactory.h

    Contains:   Header for implementation of IIccArray Handler creation factories

    Version:    V1

    Copyright:  (c) see ICC Software License
*/

/*
 * The ICC Software License, Version 0.2
 *
 *
 * Copyright (c) 2011 The International Color Consortium. All rights 
 * reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer. 
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. In the absence of prior written permission, the names "ICC" and "The
 *    International Color Consortium" must not be used to imply that the
 *    ICC organization endorses or promotes products derived from this
 *    software.
 *
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE INTERNATIONAL COLOR CONSORTIUM OR
 * ITS CONTRIBUTING MEMBERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the The International Color Consortium. 
 *
 *
 * Membership in the ICC is encouraged when this software is used for
 * commercial purposes. 
 *
 *  
 * For more information on The International Color Consortium, please
 * see <http://www.color.org/>.
 *  
 * 
 */

////////////////////////////////////////////////////////////////////// 
// HISTORY:
//
// -Jun 27, 2011 
//  A CIccArrayCreator singleton class has been added to provide general
//  support for dynamically creating array handler classes using a signature.
//  Prototype and private struct type support can be added to the system
//  by pushing additional IIccArrayFactory based objects to the 
//  singleton CIccArrayCreator object.
//
/////////////////////////////////////////////////////////////////////

#ifndef _ICCARRAYFACTORY_H
#define _ICCARRAYFACTORY_H

#include "IccDefs.h"
#include <memory>
#include <list>

//CIccArray factory support
#ifdef USEREFICCMAXNAMESPACE
namespace refIccMAX {
#endif

class IIccArray;
class CIccTagArray;

/**
 ***********************************************************************
 * Class: IIccArrayFactory
 *
 * Purpose:
 * IIccArrayFactory is a factory pattern interface for CIccArray
 * creation.
 * This class is pure virtual.
 ***********************************************************************
 */
class ICCPROFLIB_API IIccArrayFactory 
{
public:
  virtual ~IIccArrayFactory() {}

  /**
  * Function: CreateArray(structTypeSig)
  *  Create a element of type structTypeSig.
  *
  * Parameter(s):
  *  structTypeSig = signature of the ICC element type for the element to
  *  be created
  *
  * Returns a new IIArrayObject object of the given signature type.
  * If the element factory doesn't support creation of structs of type
  * structTypeSig then it should return NULL.
  */
  virtual IIccArray* CreateArray(icArraySignature structTypeSig, CIccTagArray *pTagArray=NULL)=0;

  /**
  * Function: GeArraySigName(structTypeSig)
  *  Get display name of structTypeSig.
  *
  * Parameter(s):
  *  elemName = string to put element name into, 
  *  structTypeSig = signature of the ICC element type to get a name for
  *
  * Returns true if struct type is recognized by the factory, false if
  * the factory doesn't create structTypeSig elements.
  */
  virtual bool GetArraySigName(std::string &strutName, icArraySignature structTypeSig)=0;
};


//A CIccArrayFactoryList is used by CIccArrayCreator to keep track of element
//creation factories
typedef std::list<IIccArrayFactory*> CIccArrayFactoryList;


/**
 ***********************************************************************
 * Class: CIccBasicArrayFactory
 *
 * Purpose:
 * CIccBasicArrayFactory provides creation of CIccArray handlers 
 * defined by the ICC profile specification.  The CIccArrayCreator always
 * creates a CIccBasicElemFactory.
 ***********************************************************************
 */
class CIccBasicArrayFactory : public IIccArrayFactory
{
public:
  /**
  * Function: CreateArray(structTypeSig)
  *  Create a struct object of type structTypeSig.
  *
  * Parameter(s):
  *  structTypeSig = signature of the ICC struct type for the struct to be created
  *
  * Returns a new CIccArray handler of the given signature type.
  * Unrecognized structTypeSig's will be created as a CIccArrayUnknown object.
  */
  virtual IIccArray* CreateArray(icArraySignature structSig, CIccTagArray *pTagArray=NULL);

  /**
  * Function: GetArraySigName(structTypeSig)
  *  Get display name of structTypeSig.
  *
  * Parameter(s):
  *  structName = string to put struct name into, 
  *  structTypeSig = signature of the ICC struct type to get a name for
  *
  * Returns true if struct type is recognized by the factory, false if the
  * factory doesn't create structTypeSig structs.
  */
  virtual bool GetArraySigName(std::string &structName, icArraySignature structTypeSig);
};

class CIccArrayCreator;

typedef std::auto_ptr<CIccArrayCreator> CIccArrayCreatorPtr;

/**
 ***********************************************************************
 * Class: CIccArrayCreator
 *
 * Purpose:
 * CIccArrayCreator uses a singleton pattern to provide dynamically
 * upgradeable IIccArrayObject derived object creation based on
 * element signature.
 ***********************************************************************
 */
class CIccArrayCreator 
{
public:
  ~CIccArrayCreator();

  /**
  * Function: CreateArray(structTypeSig)
  *  Create a element of type structTypeSig.
  *
  * Parameter(s):
  *  structTypeSig = signature of the ICC element type for the element to
  *  be created
  *
  * Returns a new CIccProcessArray object of the given signature type.
  * Each factory in the factoryStack is used until a factory supports the
  * signature type.
  */
  static IIccArray* CreateArray(icArraySignature arrayTypeSig, CIccTagArray *pTagArray=NULL)
      { return CIccArrayCreator::GetInstance()->DoCreateArray(arrayTypeSig, pTagArray); }

  /**
  * Function: GetArraySigName(structTypeSig)
  *  Get display name of structTypeSig.
  *
  * Parameter(s):
  *  structName = string to put struct name into
  *  structTypeSig = signature of the ICC struct type to get a name for
  *
  * Returns true if struct type is recognized by any factory, false if all
  * factories do not create structTypeSig structs. If struct type is not
  * recognized by any factories a suitable display name will be placed in
  * structName.
  */
  static bool GetArraySigName(std::string &structName, icArraySignature arrayTypeSig)
      { return CIccArrayCreator::GetInstance()->DoGetArraySigName(structName, arrayTypeSig); }

  /**
  * Function: PushFactory(pFactory)
  *  Add an IIccArrayFactory to the stack of element factories tracked by
  *  the system.
  *
  * Parameter(s):
  *  pFactory = pointer to an IIccArrayFactory object to add to the
  *    system.  The pFactory must be created with new, and will be owned
  *    CIccArrayCreator until popped off the stack using PopFactory().
  *    Any factories not popped off will be taken care of properly on
  *    application shutdown.
  *
  */
  static void PushFactory(IIccArrayFactory *pFactory)
      { CIccArrayCreator::GetInstance()->CIccArrayCreator::DoPushFactory(pFactory); }

  /**
  * Function: PopFactory()
  *  Remove the top IIccArrayFactory from the stack of element factories
  *  tracked by the system.
  *
  * Parameter(s):
  *  None
  *
  *  Returns the top IIccArrayFactory from the stack of element factories
  *  tracked by the system.  The returned element factory is no longer 
  *  owned by the system and needs to be deleted to avoid memory leaks.
  *
  *  Note: The initial CIccBasicElemFactory cannot be popped off the stack.
  */
  static IIccArrayFactory* PopFactory()
      { return CIccArrayCreator::GetInstance()->DoPopFactory(); }

private:
  /**Only GetInstance() can create the singleton*/
  CIccArrayCreator() { }

  /**
  * Function: GetInstance()
  *  Private static function to access singleton CiccArrayCreator Object.
  *
  * Parameter(s):
  *  None
  *
  * Returns the singleton CIccArrayCreator object.  It will allocate
  * a new one and push a single CIccSpecArray Factory object onto the
  * factory stack if the singleton has not been initialized.
  */
  static CIccArrayCreator* GetInstance();

  IIccArray* DoCreateArray(icArraySignature arrayTypeSig, CIccTagArray *pArray);
  bool DoGetArraySigName(std::string &elemName, icArraySignature arrayTypeSig);
  void DoPushFactory(IIccArrayFactory *pFactory);
  IIccArrayFactory* DoPopFactory(bool bAll=false);

  static CIccArrayCreatorPtr theArrayCreator; 

  CIccArrayFactoryList factoryStack;
};

#ifdef USEREFICCMAXNAMESPACE
} //namespace refIccMAX
#endif

#endif //_ICCSTRUCTFACTORY_H
