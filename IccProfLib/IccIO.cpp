/** @file
    File:       IccIO.cpp

    Contains:   Implementation of the CIccIO class.

    Version:    V1

    Copyright:  (c) see ICC Software License
*/

/*
 * The ICC Software License, Version 0.2
 *
 *
 * Copyright (c) 2003-2012 The International Color Consortium. All rights 
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

#include "IccIO.h"
#include "IccUtil.h"
#include <stdlib.h>
#include <memory.h>
#include <string.h>

#ifndef __max
#define __max(a,b)  (((a) > (b)) ? (a) : (b))
#endif
#ifndef __min
#define __min(a,b)  (((a) < (b)) ? (a) : (b))
#endif

#ifdef USEREFICCMAXNAMESPACE
namespace refIccMAX {
#endif

//////////////////////////////////////////////////////////////////////
// Class CIccIO
//////////////////////////////////////////////////////////////////////


icInt32Number CIccIO::ReadLine(void *pBuf8, icInt32Number nNum/*=256*/)
{
  icInt32Number n=0;
  icInt8Number c, *ptr=(icInt8Number*)pBuf8;

  while(n<nNum) {
    if (!Read8(&c)) {
      break;
    }
    if (c=='\n') {
      break;
    }
    else if (c!='\r') {
      *ptr++ = c;
      n++;
    }
  }
  *ptr = '\0';
  return n;
}

icInt32Number CIccIO::Read16(void *pBuf16, icInt32Number nNum)
{
  nNum = Read8(pBuf16, nNum<<1)>>1;
  icSwab16Array(pBuf16, nNum);

  return nNum;
}

icInt32Number CIccIO::Write16(void *pBuf16, icInt32Number nNum)
{
#ifndef ICC_BYTE_ORDER_LITTLE_ENDIAN
  return Write8(pBuf16, nNum<<1)>>1;
#else
  icUInt16Number *ptr = (icUInt16Number*)pBuf16;
  icUInt16Number tmp;
  icInt32Number i;

  for (i=0; i<nNum; i++) {
    tmp = *ptr;
    icSwab16(tmp);
    if (Write8(&tmp, 2)!=2)
      break;
    ptr++;
  }

  return i;
#endif
}

icInt32Number CIccIO::Read32(void *pBuf32, icInt32Number nNum)
{
  nNum = Read8(pBuf32, nNum<<2)>>2;
  icSwab32Array(pBuf32, nNum);

  return nNum;
}


icInt32Number CIccIO::Write32(void *pBuf32, icInt32Number nNum)
{
#ifndef ICC_BYTE_ORDER_LITTLE_ENDIAN
  return Write8(pBuf32, nNum<<2)>>2;
#else
  icUInt32Number *ptr = (icUInt32Number*)pBuf32;
  icUInt32Number tmp;
  icInt32Number i;

  for (i=0; i<nNum; i++) {
    tmp = *ptr;
    icSwab32(tmp);
    if (Write8(&tmp, 4)!=4)
      break;
    ptr++;
  }

  return i;
#endif
}

icInt32Number CIccIO::Read64(void *pBuf64, icInt32Number nNum)
{
  nNum = Read8(pBuf64, nNum<<3)>>3;
  icSwab64Array(pBuf64, nNum);

  return nNum;
}


icInt32Number CIccIO::Write64(void *pBuf64, icInt32Number nNum)
{
#ifndef ICC_BYTE_ORDER_LITTLE_ENDIAN
  return Write8(pBuf64, nNum<<3)>>3;
#else
  icUInt64Number *ptr = (icUInt64Number*)pBuf64;
  icUInt64Number tmp;
  icInt32Number i;

  for (i=0; i<nNum; i++) {
    tmp = *ptr;
    icSwab64(tmp);
    if (Write8(&tmp, 8)!=8)
      break;
    ptr++;
  }

  return i;
#endif
}

icInt32Number CIccIO::ReadUInt8Float(void *pBufFloat, icInt32Number nNum)
{
  icFloatNumber *ptr = (icFloatNumber*)pBufFloat;
  icUInt8Number tmp;
  icInt32Number i;

  for (i=0; i<nNum; i++) {
    if (Read8(&tmp, 1)!=1)
      break;
    *ptr = (icFloatNumber)((icFloatNumber)tmp / 255.0);
    ptr++;
  }

  return i;
}

icInt32Number CIccIO::WriteUInt8Float(void *pBufFloat, icInt32Number nNum)
{
  icFloatNumber *ptr = (icFloatNumber*)pBufFloat;
  icUInt8Number tmp;
  icInt32Number i;

  for (i=0; i<nNum; i++) {
    tmp = (icUInt8Number)(__max(0.0, __min(1.0, *ptr)) * 255.0 + 0.5);

    if (Write8(&tmp, 1)!=1)
      break;
    ptr++;
  }

  return i;
}

icInt32Number CIccIO::ReadUInt16Float(void *pBufFloat, icInt32Number nNum)
{
  icFloatNumber *ptr = (icFloatNumber*)pBufFloat;
  icUInt16Number tmp;
  icInt32Number i;

  for (i=0; i<nNum; i++) {
    if (Read16(&tmp, 1)!=1)
      break;
    *ptr = (icFloatNumber)((icFloatNumber)tmp / 65535.0);
    ptr++;
  }

  return i;
}

icInt32Number CIccIO::WriteUInt16Float(void *pBufFloat, icInt32Number nNum)
{
  icFloatNumber *ptr = (icFloatNumber*)pBufFloat;
  icUInt16Number tmp;
  icInt32Number i;

  for (i=0; i<nNum; i++) {
    tmp = (icUInt16Number)(__max(0.0, __min(1.0, *ptr)) * 65535.0 + 0.5);

    if (Write16(&tmp, 1)!=1)
      break;
    ptr++;
  }

  return i;
}

icInt32Number CIccIO::ReadFloat16Float(void *pBufFloat, icInt32Number nNum)
{
  icFloatNumber *ptr = (icFloatNumber*)pBufFloat;
  icFloat16Number tmp;
  icInt32Number i;

  for (i=0; i<nNum; i++) {
    if (Read16(&tmp, 1)!=1)
      break;
    *ptr = icF16toF(tmp);
    ptr++;
  }

  return i;
}

icInt32Number CIccIO::WriteFloat16Float(void *pBufFloat, icInt32Number nNum)
{
  icFloatNumber *ptr = (icFloatNumber*)pBufFloat;
  icUInt16Number tmp;
  icInt32Number i;

  for (i=0; i<nNum; i++) {
    tmp = icFtoF16(*ptr);

    if (Write16(&tmp, 1)!=1)
      break;
    ptr++;
  }

  return i;
}

icInt32Number CIccIO::ReadFloat32Float(void *pBufFloat, icInt32Number nNum)
{
  if (sizeof(icFloat32Number)==sizeof(icFloatNumber))
    return Read32(pBufFloat, nNum);

  icFloatNumber *ptr = (icFloatNumber*)pBufFloat;
  icFloat32Number tmp;
  icInt32Number i;

  for (i=0; i<nNum; i++) {
    if (Read32(&tmp, 1)!=1)
      break;
    *ptr = (icFloatNumber)tmp;
    ptr++;
  }

  return i;
}

icInt32Number CIccIO::WriteFloat32Float(void *pBufFloat, icInt32Number nNum)
{
  if (sizeof(icFloat32Number)==sizeof(icFloatNumber))
    return Write32(pBufFloat, nNum);

  icFloatNumber *ptr = (icFloatNumber*)pBufFloat;
  icFloat32Number tmp;
  icInt32Number i;

  for (i=0; i<nNum; i++) {
    tmp = (icFloat32Number)*ptr;

    if (Write32(&tmp, 1)!=1)
      break;
    ptr++;
  }

  return i;
}

bool CIccIO::Align32()
{
  int mod = GetLength() % 4;
  if (mod != 0) {
    icUInt8Number buf[4]={0,0,0,0};
    if (Seek(0, icSeekEnd)<0)
      return false;

    if (Write8(buf, 4-mod) != 4-mod)
      return false;
  }

  return true;

}

bool CIccIO::Sync32(icUInt32Number nOffset)
{
  nOffset &= 0x3;

  icUInt32Number nPos = ((Tell() - nOffset + 3)>>2)<<2;
  if (Seek(nPos + nOffset, icSeekSet)<0)
    return false;
  return true;
}


//////////////////////////////////////////////////////////////////////
// Class CIccFileIO
//////////////////////////////////////////////////////////////////////

CIccFileIO::CIccFileIO() : CIccIO()
{
  m_fFile = NULL;
}

CIccFileIO::~CIccFileIO()
{
  Close();
}

bool CIccFileIO::Open(const icChar *szFilename, const icChar *szAttr)
{
#ifdef WIN32
  char myAttr[20];

  if (!strchr(szAttr, 'b')) {
    myAttr[0] = szAttr[0];
    myAttr[1] = 'b';
    strcpy(myAttr+2, szAttr+1);
    szAttr = myAttr;
  }
#endif

  if (m_fFile)
    fclose(m_fFile);

  m_fFile = fopen(szFilename, szAttr);

  return m_fFile != NULL;
}


#ifdef WIN32
bool CIccFileIO::Open(const icWChar *szFilename, const icWChar *szAttr)
{
  icWChar myAttr[20];

  if (!wcschr(szAttr, 'b')) {
    myAttr[0] = szAttr[0];
    myAttr[1] = 'b';
    wcscpy(myAttr+2, szAttr+1);
    szAttr = myAttr;
  }

  if (m_fFile)
    fclose(m_fFile);

  m_fFile = _wfopen(szFilename, szAttr);

  return m_fFile != NULL;
}
#endif


bool CIccFileIO::Attach(FILE *f)
{
  if (m_fFile)
    fclose(m_fFile);

  m_fFile = f;

  return m_fFile != NULL;
}


void CIccFileIO::Detach()
{
  m_fFile = NULL;
}


void CIccFileIO::Close()
{
  if (m_fFile) {
    fclose(m_fFile);
    m_fFile = NULL;
  }
}


icInt32Number CIccFileIO::Read8(void *pBuf, icInt32Number nNum)
{
  if (!m_fFile)
    return 0;

  return (icInt32Number)fread(pBuf, 1, nNum, m_fFile);
}


icInt32Number CIccFileIO::Write8(void *pBuf, icInt32Number nNum)
{
  if (!m_fFile)
    return 0;

  return (icInt32Number)fwrite(pBuf, 1, nNum, m_fFile);
}


icInt32Number CIccFileIO::GetLength()
{
  if (!m_fFile)
    return 0;

  fflush(m_fFile);
  icInt32Number current = (icInt32Number)ftell(m_fFile), end;
  fseek (m_fFile, 0, SEEK_END);
  end = (icInt32Number)ftell(m_fFile);
  fseek (m_fFile, current, SEEK_SET);
  return end;
}


icInt32Number CIccFileIO::Seek(icInt32Number nOffset, icSeekVal pos)
{
  if (!m_fFile)
    return -1;

  return !fseek(m_fFile, nOffset, pos) ? (icInt32Number)ftell(m_fFile) : -1;
}


icInt32Number CIccFileIO::Tell()
{
  if (!m_fFile)
    return -1;

  return (icInt32Number)ftell(m_fFile);
}


//////////////////////////////////////////////////////////////////////
// Class CIccEmbedIO
//////////////////////////////////////////////////////////////////////

CIccEmbedIO::CIccEmbedIO() : CIccIO()
{
  m_pIO = NULL;
  m_nStartPos = 0;
  m_nSize = -1;
  m_bOwnIO = false;
}

CIccEmbedIO::~CIccEmbedIO()
{
  Close();
}

bool CIccEmbedIO::Attach(CIccIO *pIO, icInt32Number nSize/* =0 */, bool bOwnIO/* =false */)
{
  if (!pIO)
    return false;

  m_nStartPos = pIO->Tell();
  m_nSize = nSize;
  m_bOwnIO = bOwnIO;
  m_pIO = pIO;

  if (m_nStartPos < 0)
    return false;

  return true;
}


void CIccEmbedIO::Close()
{
  if (m_pIO && m_bOwnIO) {
    m_pIO->Close();

    delete m_pIO;
    m_pIO = NULL;
  }
}


icInt32Number CIccEmbedIO::Read8(void *pBuf, icInt32Number nNum)
{
  if (!m_pIO)
    return 0;

  if (m_nSize > 0) {
    icUInt32Number nPos = m_pIO->Tell();
    icUInt32Number nOffset = nPos - m_nStartPos;

    if (nOffset + nNum > (icUInt64Number)m_nSize)
      nNum = m_nSize - nOffset;
  }

  return m_pIO->Read8(pBuf, nNum);
}


icInt32Number CIccEmbedIO::Write8(void *pBuf, icInt32Number nNum)
{
  if (!m_pIO)
    return 0;

  return m_pIO->Write8(pBuf, nNum);
}


icInt32Number CIccEmbedIO::GetLength()
{
  if (!m_pIO)
    return 0;

  if (m_nSize)
    return m_nSize;

  return m_pIO->GetLength() - m_nStartPos;
}


icInt32Number CIccEmbedIO::Seek(icInt32Number nOffset, icSeekVal pos)
{
  icInt32Number nPos;
  if (!m_pIO)
    return -1;

  if (pos == icSeekSet) {
    if (m_nSize > 0 && nOffset > m_nSize)
      nOffset = m_nSize;
    else if (nOffset < 0)
      nOffset = m_nStartPos;

   nPos = m_pIO->Seek(nOffset + m_nStartPos, icSeekSet);
    
  }
  else if (pos == icSeekEnd) {
    if (m_nSize > 0) {
      nOffset = m_nSize + nOffset;
    }
    else {
      nOffset = nOffset + m_pIO->GetLength() - m_nStartPos;
    }
    if (nOffset < 0)
      nOffset = 0;
    nOffset += m_nStartPos;

    nPos = m_pIO->Seek(nOffset, icSeekSet);
  }
  else {//pos == icSeekCur
    nOffset = m_pIO->Tell() + nOffset;

    if (m_nSize && nOffset - m_nStartPos > m_nSize)
      nOffset = m_nStartPos + m_nSize;
    else if (nOffset < m_nStartPos)
      nOffset = m_nStartPos;

    nPos = m_pIO->Seek(nOffset, icSeekSet);
  }

  if (nPos >= m_nStartPos)
    return nPos - m_nStartPos;

  return nPos;
}


icInt32Number CIccEmbedIO::Tell()
{
  if (!m_pIO)
    return -1;

  icUInt32Number nPos = m_pIO->Tell();

  if ((icInt32Number)nPos >= m_nStartPos)
    return nPos - m_nStartPos;

  return nPos;
}


//////////////////////////////////////////////////////////////////////
// Class CIccMemIO
//////////////////////////////////////////////////////////////////////

CIccMemIO::CIccMemIO() : CIccIO()
{
  m_pData = NULL;
  m_nSize = 0;
  m_nAvail = 0;
  m_nPos = 0;

  m_bFreeData = false;
}

CIccMemIO::~CIccMemIO()
{
  Close();
}


bool CIccMemIO::Alloc(icUInt32Number nSize, bool bWrite)
{
  if (m_pData)
    Close();

  icUInt8Number *pData = (icUInt8Number*)malloc(nSize);

  if (!pData)
    return false;

  if (!Attach(pData, nSize, bWrite)) {
    free(pData);
    return false;
  }

  m_bFreeData = true;

  return true;
}


bool CIccMemIO::Attach(icUInt8Number *pData, icUInt32Number nSize, bool bWrite)
{
  if (!pData)
    return false;

  if (m_pData)
   Close();

  m_pData = pData;
  m_nPos = 0;

  if (bWrite) {
    m_nAvail = nSize;
    m_nSize = 0;
  }
  else {
    m_nAvail = m_nSize = nSize;
  }

  return true;
}


void CIccMemIO::Close()
{
  if (m_pData) {
    if (m_bFreeData) {
      free(m_pData);

      m_bFreeData = false;
    }
    m_pData = NULL;
  }
}


icInt32Number CIccMemIO::Read8(void *pBuf, icInt32Number nNum)
{
  if (!m_pData)
    return 0;
  if (nNum > 0) {
      nNum = __min((icInt32Number) (m_nSize - m_nPos), nNum);
      memcpy(pBuf, m_pData + m_nPos, nNum);
      m_nPos += nNum;
  }
    return nNum;
}


icInt32Number CIccMemIO::Write8(void *pBuf, icInt32Number nNum)
{
  if (!m_pData)
    return 0;

  nNum = __min((icInt32Number)(m_nAvail-m_nPos), nNum);

  memcpy(m_pData + m_nPos, pBuf, nNum);

  m_nPos += nNum;
  if (m_nPos > m_nSize)
    m_nSize = m_nPos;

  return nNum;
}


icInt32Number CIccMemIO::GetLength()
{
  if (!m_pData)
    return 0;

  return m_nSize;
}


icInt32Number CIccMemIO::Seek(icInt32Number nOffset, icSeekVal pos)
{
  if (!m_pData)
    return -1;

  icInt32Number nPos;
  switch(pos) {
  case icSeekSet:
    nPos = nOffset;
    break;
  case icSeekCur:
    nPos = (icInt32Number)m_nPos + nOffset;
    break;
  case icSeekEnd:
    nPos = (icInt32Number)m_nSize + nOffset;
    break;
  default:
    nPos = 0;
    break;
  }

  if (nPos < 0)
    return -1;

  icUInt32Number uPos = (icUInt32Number)nPos;

  if (uPos > m_nSize && m_nSize != m_nAvail && uPos <=m_nAvail) {
    memset(m_pData+m_nSize, 0, (icInt32Number)(uPos - m_nSize));
    m_nSize = uPos;
  }
  if (uPos > m_nSize)
    return -1;

  m_nPos = uPos;

  return nPos;
}


icInt32Number CIccMemIO::Tell()
{
  if (!m_pData)
    return -1;

  return (icInt32Number)m_nPos;
}

///////////////////////////////

//////////////////////////////////////////////////////////////////////
// Class CIccNullIO
//////////////////////////////////////////////////////////////////////

CIccNullIO::CIccNullIO() : CIccIO()
{
  m_nSize = 0;
  m_nPos = 0;
}

CIccNullIO::~CIccNullIO()
{
  Close();
}


void CIccNullIO::Open()
{
  m_nPos = 0;
  m_nSize = 0;
}


void CIccNullIO::Close()
{
}


icInt32Number CIccNullIO::Read8(void *pBuf, icInt32Number nNum)
{
  icInt32Number nLeft = m_nSize - m_nPos;
  icInt32Number nRead = (nNum <= (icInt32Number)nLeft) ? nNum : nLeft;

  memset(pBuf, 0, nRead);
  m_nPos += nRead;

  return nRead;
}


icInt32Number CIccNullIO::Write8(void *pBuf, icInt32Number nNum)
{
  m_nPos += nNum;
  if (m_nPos > m_nSize)
    m_nSize = m_nPos;
  
  return nNum;
}


icInt32Number CIccNullIO::GetLength()
{
  return m_nSize;
}


icInt32Number CIccNullIO::Seek(icInt32Number nOffset, icSeekVal pos)
{
  icInt32Number nPos;
  switch(pos) {
  case icSeekSet:
    nPos = nOffset;
    break;
  case icSeekCur:
    nPos = (icInt32Number)m_nPos + nOffset;
    break;
  case icSeekEnd:
    nPos = (icInt32Number)m_nSize + nOffset;
    break;
  default:
    nPos = 0;
    break;
  }

  if (nPos < 0)
    return -1;

  m_nPos = (icUInt32Number)nPos;

  if (m_nPos>m_nSize)
    m_nSize = m_nPos;

  return nPos;
}


icInt32Number CIccNullIO::Tell()
{
  return (icInt32Number)m_nPos;
}


#ifdef USEREFICCMAXNAMESPACE
} //namespace refIccMAX
#endif
