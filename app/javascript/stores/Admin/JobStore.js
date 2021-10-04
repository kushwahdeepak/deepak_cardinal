import React from 'react';
import { makeRequest } from '../../components/common/RequestAssist/RequestAssist'
import validator from 'validator'

const initialState = {
  job:null,
  organization_id:'',
  name:'',
  description:'',
  skills:'',
  nice_to_have_skills:'',
  notificationemails:'',
  referral_amount:'',
  keywords:'',
  nice_to_have_keywords:'',
  department:'',
  experience_years:'',
  prefered_titles:'',
  prefered_industries:'',
  school_names:'',
  company_names:'',
  location_names:'',
  status:''
}   

const reducer = (state, action) => {  
  const {type, value} = action
  switch(type) {
    case 'add_job':
      const formData = new FormData()
      for (const key in value) {
          formData.append(`job[${key}]`, value[key])
      }
      const url = `/admin/jobs`
      sendRequest(formData, url, 'post')
      return {...state, ...value}
    case 'update_job':
      const formDataUpdate = new FormData()
      for (const key in value) {
        formDataUpdate.append(`job[${key}]`, value[key])
      }
      const urlUpdate = `/admin/jobs/${action.id}`
      sendRequest(formDataUpdate, urlUpdate, 'put')
      return {...state, ...value}
    default:
      return state
  }
}

async function sendRequest(formData, url, method) {
  await makeRequest(url, method, formData, {
      contentType: 'application/json',
      loadingMessage: 'Submitting...',
      createSuccessMessage: () => 'Job created Successfully',
      createErrorMessage: (e) => 'Failed to create a job',
      onSuccess: () => {
          console.log("job created successuffully..")
          window.location.href = '/admin/jobs'
      },
  });
}

// context for user profile page
const JobStoreContext = React.createContext(null)
export {initialState, reducer, JobStoreContext}