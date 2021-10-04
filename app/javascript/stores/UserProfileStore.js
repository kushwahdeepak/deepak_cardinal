import React from 'react';
import { makeRequest } from '../components/common/RequestAssist/RequestAssist'
import validator from 'validator'

const initialState = {
  currentUser: null,
  person: null,
  firstName: '',
  lastName: '',
  employer: '',
  title: '',
  school: '',
  location: '',
  skills: '',
  description: '',
  avatar_url: null,
  experiences: [],
  deleteExperienceId: [],
  skillset: '',
}

const reducer = (state, action) => {
  const {type, value} = action
  switch(type) {
    case 'update_user_profile':
      const {first_name, last_name, employer, school, title, location, skills, description, currentUser, avatar_url, experiences, deleteExperienceId} = value  
     
      
      
       
        const formData = new FormData()
        formData.append('person[first_name]', first_name)
        formData.append('person[last_name]', last_name)
        if(employer != null){
          formData.append('person[employer]', employer)
        }
        if(school != null){
          formData.append('person[school]',  school)
        }
        if(title != null){
          formData.append('person[title]',  title)
        }
        if(location != null){
          formData.append('person[location]', location)
        }
        if(description != null){
          formData.append('person[description]', description)
        }
        formData.append('person[skills]', skills.join(','))
        formData.append('id', currentUser.id)

        if(typeof avatar_url == 'object' && avatar_url != null) {
          formData.append('person[avatar]', avatar_url)
        }

        formData.append(
            'person[experiences]',
            JSON.stringify(experiences)
        )
        formData.append(
            'person[remove_exp_id]',
            JSON.stringify(deleteExperienceId)
        )

        const url = `${currentUser.id}`
        sendRequest(formData, url)
     
      return {...state, ...value}
    default:
      return state
  }
}

async function sendRequest(formData, url) {

  await makeRequest(url, 'put', formData, {
    contentType: 'multipart/form-data',
    loadingMessage: 'Submitting...',
    createResponseMessage: () => {
      return {
        message: 'Update successful',
        messageType: 'success',
        loading: false,
        autoClose: true,
    }
    },
    onSuccess: () => {
    window.location.reload()
    }
   })
}

// context for user profile page
const UserProfileContext = React.createContext(null)

export {initialState, reducer, UserProfileContext}