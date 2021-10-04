import React from 'react';
import { makeRequest } from '../../components/common/RequestAssist/RequestAssist'; 

let initialState = {
    ...initialState,
    ...{
        organization:null,
        name:'',
        industry:'',
        company_size:'',
        description:'',
        country:'',
        region:'',
        city:'',
        status:'',
        logo:''
    }
}

const reducer = (state, action) => {
  const {type, value, id } = action
  let url = ''
  let formData = {}
  switch(type) {
    case 'save-organization':
        formData = new FormData()
        for (const key in value) {
            if (key === 'logo') {
                if (typeof value[key] !== 'string') {
                    formData.append(`organization[${key}]`, value[key])
                }
            } else {
                formData.append(`organization[${key}]`, value[key])
            }
        }
        url = `/admin/organizations/${id}.json`
        sendRequest(formData,url,'put')
        return {...state, ...value}
    case 'approve-organization':
        url = `/admin/organizations/${id}/approve`
        sendRequest({},url,'put')
        return {...state}
    case 'reject-organization':
        url = `/admin/organizations/${id}/reject`
        sendRequest({},url,'put')
        return {...state}
    case 'add-recruiter':
        formData = new FormData()
        formData.append(`recruiter_organizations[organization_id]`, id)
        formData.append(`recruiter_organizations[members]`,JSON.stringify(value))
        url = `/admin/recruiter_organizations`
        sendRequest(formData,url,'post')
        return {...state, ...value}
    case 'remove-recruiter-organization':
        url = `/admin/recruiter_organizations/${id}`
        sendRequest({},url,'delete')
        return {...state}
    default:
        return state
  }
}

async function sendRequest(formData, url, method) {
    const messsage = method == 'put' ? 'Update' : method == 'post' ? 'Save' : 'Remove' 
    await makeRequest(url, method, formData, {
        contentType: 'multipart/form-data',
        loadingMessage: 'Submitting...',
        createResponseMessage: () => {
            return {
                message: `${messsage} successful`,
                messageType: 'success',
                loading: false,
                autoClose: true,
            }
        },
        createSuccessMessage: () => `${messsage} successful`,
        createErrorMessage: (e) => e.response.data.msg,
        onSuccess: () => {
        window.location.reload()
        }
    })
}

// context for organization admin page
const OrganizationContext = React.createContext(null)

export {initialState, reducer, OrganizationContext}