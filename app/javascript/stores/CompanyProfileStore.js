import React from 'react';
import { makeRequest } from '../components/common/RequestAssist/RequestAssist'

const initialState = {
  id: null,
  name: '',
  description: '',
  industry: '',
  min_size: null,
  max_size: null,
  region: '',
  city: '',
  country:'',
  jobs: [],
  logo_url: null,
  company_size: null,
  isEmployer: false,
  companySizes: [],
  industryTypes: [],
}

const reducer = (state, action) => {
  const {type, value} = action
  switch(type) {
    case 'update_state':
      return {...state, ...value}
    case 'update_company_profile':
      const url = `/organizations/${value.id}`
      const formData = new FormData()
      formData.append('organization[name]', value.name)
      formData.append('organization[description]', value.description)
      formData.append('organization[industry]', value.industry)
      formData.append('organization[min_size]', value.min_size)
      formData.append('organization[max_size]', value.max_size)
      formData.append('organization[country]', value.country)
      formData.append('organization[region]', value.region)
      formData.append('organization[city]', value.city)
      formData.append('organization[company_size]', value.company_size)
      formData.append('id', value.id)
      if (value.logo_url != null && typeof value.logo_url == 'object')
        formData.append('organization[logo]', value.logo_url)
      
      sendRequest(formData, url).then(() => {
        if(typeof value.logo_url == 'object'){
          if(localStorage.getItem('requestFailed') === null){
            value.logo_url = URL.createObjectURL(value.logo_url)
            return {...state, ...value}
          }
        }
      })
    
      if(localStorage.getItem('requestFailed') === null){
        return {...state, ...value}
      }
    case 'set_company_size_and_industry_types':
      if(localStorage.getItem('requestFailed') === null){
        return {...state, ...value}
      }  
    default:
      return state
  }
}

async function sendRequest(formData, url) {
  await makeRequest(url, 'put', formData, {
    contentType: 'multipart/form-data',
    loadingMessage: 'Submitting...',
    createResponseMessage: (response) => {
      return {
        message: response
            ? response.message ? response.message : response.failure
            : 'Update successful',
        messageType: response.message ? 'success' : 'failure',
        loading: false,
        autoClose: true,
     }
    },
  })
}

// context for company profile page
const StoreCompanyContext = React.createContext(null)

export {initialState, reducer, StoreCompanyContext}
