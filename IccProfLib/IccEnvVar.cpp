#include "IccEnvVar.h"

CIccCmmVarLookup::CIccCmmVarLookup(icCmmEnvSigMap &map)
{
  m_map = new icCmmEnvSigMap();
  *m_map = map;
}

CIccCmmVarLookup::~CIccCmmVarLookup()
{
  delete m_map;
}

bool CIccCmmVarLookup::GetEnvVar(icSigCmmEnvVar sig, icFloatNumber &val)
{
  icCmmEnvSigMap::iterator v=m_map->find((icSignature)sig);

  if (v==m_map->end()) {
    val = (icFloatNumber)0.0;
    return false;
  }
  val = v->second;
  return true;
}

bool CIccCmmVarLookup::IndexedEnvVar(icUInt32Number nIndex, icSigCmmEnvVar &sig, icFloatNumber &val)
{
  if (nIndex>=m_map->size()) {
    sig = (icSigCmmEnvVar)0;
    val = (icFloatNumber)0.0;
    return false;
  }
  icUInt32Number i;
  icCmmEnvSigMap::iterator v;

  for (v=m_map->begin(), i=0; i<nIndex; v++, i++);

  sig = (icSigCmmEnvVar)(v->first);
  val = v->second;
  return true;
}

CIccCmmEnvVarHint::CIccCmmEnvVarHint(icCmmEnvSigMap &map)
{
  m_map = new icCmmEnvSigMap();
  *m_map = map;
}

CIccCmmEnvVarHint::~CIccCmmEnvVarHint()
{
  delete m_map;
}

