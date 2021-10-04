import React, {useCallback, useState, createContext} from 'react'

const Step3Context = createContext()
function Step3ContextProvider(props) {
  const [mustHaveKeyword, setMustHaveKeyword] = useState()
  const [niceToHaveKeyword, setNiceToHaveKeyword] = useState()
  const [educationPreferrence, setEducationPreferrence] = useState()
  const [companyPreferrence, setCompanyPreferrence] = useState()
  const [locationPreferrence, setLocationPreferrence] = useState()
  const [preferredIndustry, setPreferredIndustry] = useState()
  const [experienceYears, setExperienceYears] = useState()
  const [preferredTitles, setPreferredTitles] = useState()
  const [companyPreferrenceSpecifySelected, setCompanyPreferrenceSpecifySelected] = useState([]);
  const [educationPreferrenceSpecifySelected, setEducationPreferrenceSpecifySelected] = useState([]);
  const [locationPreferrenceSpecifySelected, setLocationPreferrenceSpecifySelected] = useState([]);

  const value = {
    mustHaveKeyword,
    niceToHaveKeyword,
    educationPreferrence,
    companyPreferrence,
    locationPreferrence,
    experienceYears,
    preferredIndustry,
    preferredTitles,
    companyPreferrenceSpecifySelected,
    educationPreferrenceSpecifySelected,
    locationPreferrenceSpecifySelected,


    setMustHaveKeyword,
    setNiceToHaveKeyword,
    setEducationPreferrence,
    setCompanyPreferrence,
    setLocationPreferrence,
    setExperienceYears,
    setPreferredIndustry,
    setPreferredTitles,
    setCompanyPreferrenceSpecifySelected,
    setEducationPreferrenceSpecifySelected,
    setLocationPreferrenceSpecifySelected
  }

  return (
    <Step3Context.Provider value={value}>{props.children}</Step3Context.Provider>
  )
}

const Step3ContextConsumer = Step3Context.Consumer

export {Step3Context, Step3ContextProvider, Step3ContextConsumer}
export default Step3ContextProvider;
