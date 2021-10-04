import React, {useCallback, useState, createContext} from 'react'

const Step1Context = createContext()
function Step1ContextProvider(props) {
  const [id, setId] = useState()
  const [name, setName] = useState()
  const [title, setTitle] = useState()
  const [location, setLocation] = useState()
  const [description, setDescription] = useState()
  const [musthave, setMustHave] = useState()
  const [nicetohave, setNiceToHave] = useState()
  const [emailStepOne, setEmailStepOne] = useState()
  const [referrals,setReferrals] = useState()
  const [money, setMoney] = useState()
  const [locationDepartment, setLocationDepartment] = useState()
  const [locationFilter, setLocationFilter] = useState([])
  const [locationSearch, setLocationSearch] = useState('')

  const value = {
    id,
    name,
    title,
    location,
    description,
    musthave,
    nicetohave,
    emailStepOne,
    referrals,
    money,
    locationDepartment,
    locationFilter,
    locationSearch,

    setId,
    setName,
    setTitle,
    setLocation,
    setDescription,
    setMustHave,
    setNiceToHave,
    setEmailStepOne,
    setReferrals,
    setMoney,
    setLocationDepartment,
    setLocationFilter,
    setLocationSearch,
  }

  return (
    <Step1Context.Provider value={value}>{props.children}</Step1Context.Provider>
  )
}

const Step1ContextConsumer = Step1Context.Consumer

export {Step1Context, Step1ContextProvider, Step1ContextConsumer}
export default Step1ContextProvider;
