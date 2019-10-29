/** @file
File:       IccTagEmbedIcc.cpp

Contains:   Implementation of the CIccTagEmbedProfile class

Version:    V1

Copyright:  ? see ICC Software License
*/

/*
* The ICC Software License, Version 0.2
*
*
* Copyright (c) 2003-2018 The International Color Consortium. All rights
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
// -Initial implementation by Max Derhak 5-15-2003
//
//////////////////////////////////////////////////////////////////////

#ifdef WIN32
#pragma warning( disable: 4786) //disable warning in <list.h>
#include <windows.h>
#endif
#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include "IccTagEmbedIcc.h"
#include "IccUtil.h"
#include "IccProfile.h"
#include "IccTagFactory.h"
#include "IccIO.h"

/**
****************************************************************************
* Name: CIccTagEmbedProfile::CIccTagEmbedProfile
*
* Purpose: Constructor
*
*****************************************************************************
*/
CIccTagEmbeddedProfile::CIccTagEmbeddedProfile()
{
  m_pProfile = NULL;
}

/**
****************************************************************************
* Name: CIccTagEmbedProfile::CIccTagEmbedProfile
*
* Purpose: Copy Constructor
*
* Args:
*  ITU = The CIccTagEmbedProfile object to be copied
*****************************************************************************
*/
CIccTagEmbeddedProfile::CIccTagEmbeddedProfile(const CIccTagEmbeddedProfile &ITEP)
{
  if (ITEP.m_pProfile) {
    m_pProfile = ITEP.m_pProfile->NewCopy();
  }
  else
    m_pProfile = NULL;
}

/**
****************************************************************************
* Name: CIccTagEmbedProfile::operator=
*
* Purpose: Copy Operator
*
* Args:
*  UnknownTag = The CIccTagEmbedProfile object to be copied
*****************************************************************************
*/
CIccTagEmbeddedProfile &CIccTagEmbeddedProfile::operator=(const CIccTagEmbeddedProfile &ITEP)
{
  if (&ITEP == this)
    return *this;

  if (m_pProfile)
    delete m_pProfile;

  if (ITEP.m_pProfile)
    m_pProfile = ITEP.m_pProfile->NewCopy();
  else
    m_pProfile = NULL;

  return *this;
}

/**
****************************************************************************
* Name: CIccTagEmbedProfile::~CIccTagEmbedProfile
*
* Purpose: Destructor
*****************************************************************************
*/
CIccTagEmbeddedProfile::~CIccTagEmbeddedProfile()
{
  if (m_pProfile)
    delete m_pProfile;
}


/**
****************************************************************************
* Name: CIccTagEmbedProfile::Read
*
* Purpose: Read in an unknown tag type into a data block
*
* Args:
*  size - # of bytes in tag,
*  pIO - IO object to read tag from
*  pProfile - pProfile object calling read
*
* Return:
*  true = successful, false = failure
*****************************************************************************
*/
bool CIccTagEmbeddedProfile::Read(icUInt32Number size, CIccIO *pIO, CIccProfile *pProfile)
{
  if (size<sizeof(icTagTypeSignature) || !pIO) {
    return false;
  }

  icTagTypeSignature nType;

  if (!pIO->Read32(&nType))
    return false;
  
  if (nType != GetType())
    return false;

  size = size - sizeof(icTagTypeSignature);

  if (size < sizeof(m_nReserved))
    return false;

  if (!pIO->Read32(&m_nReserved))
    return false;

  size = size - sizeof(m_nReserved);

  CIccEmbedIO *pEmbedIO = new CIccEmbedIO();

  if (!pEmbedIO->Attach(pIO, size)) {
    delete pEmbedIO;
    return false;
  }

  if (m_pProfile)
    delete m_pProfile;

  m_pProfile = pProfile ? pProfile->NewProfile() : new CIccProfile();

  if (pProfile && pProfile->HasIO()) {
    if (!m_pProfile->Attach(pEmbedIO)) {
      delete pEmbedIO;
      delete m_pProfile;
      m_pProfile = NULL;

      return false;
    }
  }
  else {
    bool stat = m_pProfile->Read(pEmbedIO);
    delete pEmbedIO;

    if (!stat) {
      delete m_pProfile;
      m_pProfile = NULL;

      return false;
    }

    return stat;
  }

  return true;
}

/**
****************************************************************************
* Name: CIccTagEmbedProfile::ReadAll
*
* Purpose: Read all tags associated with the embedded profile
*
*
* Return:
*  true = successful, false = failure
*****************************************************************************
*/
bool CIccTagEmbeddedProfile::ReadAll()
{
  if (!m_pProfile)
    return true;

  return m_pProfile->ReadTags(m_pProfile);
}


/**
****************************************************************************
* Name: CIccTagEmbedProfile::Write
*
* Purpose: Write an unknown tag to a file
*
* Args:
*  pIO - The IO object to write tag to.
*
* Return:
*  true = succesful, false = failure
*****************************************************************************
*/
bool CIccTagEmbeddedProfile::Write(CIccIO *pIO)
{
  if (!pIO)
    return false;

  icTagTypeSignature nType = GetType();

  if (!pIO->Write32(&nType))
    return false;

  if (!pIO->Write32(&m_nReserved))
    return false;


  if (m_pProfile) {
    CIccEmbedIO embedIO;
    if (!embedIO.Attach(pIO))
      return false;

    icProfileIDSaveMethod bWriteId = (m_pProfile->m_Header.profileID.ID32[0] ||
                                      m_pProfile->m_Header.profileID.ID32[1] ||
                                      m_pProfile->m_Header.profileID.ID32[2] ||
                                      m_pProfile->m_Header.profileID.ID32[3]) ? icAlwaysWriteID : icVersionBasedID;
    bool rv = m_pProfile->Write(&embedIO, bWriteId);
    return rv;
  }

  return true;
}


/**
****************************************************************************
* Name: CIccTagEmbedProfile::Describe
*
* Purpose: Dump data associated with unknown tag to a string
*
* Args:
*  sDescription - string to concatenate tag dump to
*****************************************************************************
*/
void CIccTagEmbeddedProfile::Describe(std::string &sDescription)
{
  if (m_pProfile) {
    sDescription += "Embedded profile in Tag\r\n";

    //TODO - get description from profile
  }
  else {
    sDescription += "No profile embedded in Tag\r\n";
  }
}

/**
******************************************************************************
* Name: CIccTagEmbedProfile::Validate
*
* Purpose: Check tag data validity.  In base class we only look at the
*  tag's reserved data value
*
* Args:
*  sig = signature of tag being validated,
*  sReport = String to add report information to
*
* Return:
*  icValidateStatusOK if valid, or other error status.
******************************************************************************
*/
icValidateStatus CIccTagEmbeddedProfile::Validate(std::string sigPath, std::string &sReport, const CIccProfile* pProfile/*=NULL*/) const
{
  icValidateStatus rv = CIccTag::Validate(sigPath, sReport, pProfile);

  CIccInfo Info;

  if (!m_pProfile) {
    sReport += icMsgValidateWarning;
    sReport += Info.GetSigPathName(sigPath);
    sReport += " - No Profile defined for embedded profile tag.\r\n";

    rv = icMaxStatus(rv, icValidateWarning);
    return rv;
  }

  rv = icMaxStatus(rv, m_pProfile->Validate(sReport, sigPath));

  if (pProfile) {
    if (m_pProfile->m_Header.colorSpace != pProfile->m_Header.colorSpace) {
      sReport += icMsgValidateCriticalError;
      sReport += Info.GetSigPathName(sigPath);
      sReport += " - color space does not match for embedded profile.\r\n";

      rv = icMaxStatus(rv, icValidateCriticalError);
    }
    if (m_pProfile->m_Header.deviceClass != pProfile->m_Header.deviceClass) {
      sReport += icMsgValidateCriticalError;
      sReport += Info.GetSigPathName(sigPath);
      sReport += " - device class does not match for embedded profile.\r\n";

      rv = icMaxStatus(rv, icValidateCriticalError);
    }
  }
  
  return rv;
}