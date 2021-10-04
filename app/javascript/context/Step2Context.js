import React, {useCallback, useState, createContext} from 'react'

const Step2Context = createContext()
function Step2ContextProvider(props) {
  const [subject, setSubject] = useState()
  const [email, setEmail] = useState()
  const [sms, setSms] = useState()

  const value = {
 
    subject,
    email,
    sms,
  
    setSubject,
    setEmail,
    setSms,
  }

  return (
    <Step2Context.Provider value={value}>{props.children}</Step2Context.Provider>
  )
}

const Step2ContextConsumer = Step2Context.Consumer

export {Step2Context, Step2ContextProvider, Step2ContextConsumer}
export default Step2ContextProvider;
