import React from 'react'
import CustomModalContextProvider from '../context/CustomModalContext'
import Step1ContextProvider from '../context/Step1Context'
import Step2ContextProvider from '../context/Step2Context'
import Step3ContextProvider from '../context/Step3Context'

function Initialize({children}) {
  return (
    <CustomModalContextProvider>
      <Step1ContextProvider>
        <Step2ContextProvider>
          <Step3ContextProvider>
            {children}
          </Step3ContextProvider>
        </Step2ContextProvider>
      </Step1ContextProvider>
    </CustomModalContextProvider>
  )
}

export default Initialize