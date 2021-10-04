import React, {useCallback, useState, createContext} from 'react'

const CustomModalContext = createContext()

function CustomModalContextProvider(props) {
  const [barState, setBarState] = useState({
    activeCreateForm: 0,
    formState: true,
  })
  const [loaderResponse, setLoaderResponse] = useState(false)
  const [testing, setTesting] = useState()
  const [jobStore, setJobStore] = useState()
  const [errorTextCustom, setErrorTextCustom] = useState('')
  const [errorMessageCustom, setErrorMessageCustom] = useState('')
  const [emailJob, setEmailJob] = useState('')

  const handleIncreaseDecreaseStep = useCallback(
    (updatedStep, err) => {
      var index = err
        .map(function(e) {
          return e.error_field
        })
        .indexOf('name')

      setBarState({
        ...barState,
        activeCreateForm: updatedStep,
        formState: true,
      })
    },
    [barState]
  )

  const handleChangeCreateForm = useCallback(
    step => {
      if (step === 0) {
        handleIncreaseDecreaseStep(0, [])
      } else if (step === 1) {
          handleIncreaseDecreaseStep(1, [])
      } else if (step === 2) {
          handleIncreaseDecreaseStep(2, [])         
      } else if (step === 3) {
          handleIncreaseDecreaseStep(3, [])          
      }},
    [handleIncreaseDecreaseStep]
  )

  const handleStatusforPreviousNextButton = useCallback(
    val => {
      setBarState({
        ...barState,
        formState: false,
      })
      handleChangeCreateForm(
        barState.activeCreateForm >= 0 && barState.activeCreateForm < 4
          ? barState.activeCreateForm + val
          : 0
      )
    },
    [setBarState, handleChangeCreateForm, barState]
  )
  
  const value = {
    ...barState,
    setBarState,
    handleStatusforPreviousNextButton,
    handleIncreaseDecreaseStep,
    handleChangeCreateForm,
    loaderResponse,
    setLoaderResponse,
    testing,
    setTesting,
    jobStore,
    setJobStore,
    errorTextCustom,
    setErrorTextCustom,
    errorMessageCustom,
    setErrorMessageCustom,
    setEmailJob,
    emailJob
  }

  return (
    <CustomModalContext.Provider value={value}>{props.children}</CustomModalContext.Provider>
  )
}

const CustomModalContextConsumer = CustomModalContext.Consumer

export {CustomModalContext, CustomModalContextProvider, CustomModalContextConsumer}
export default CustomModalContextProvider;
