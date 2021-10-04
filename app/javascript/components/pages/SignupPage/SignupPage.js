import React, { useState, useEffect } from 'react'

import CreateAccountPage from './CreateAccountPage'
import ChooseRolePage from './ChooseRolePage'
import CreateOrganizationPage from './CreateOrganizationPage'
import ContactDetailPage from './ContactDetailPage'
import AgreementsPage from './AgreementsPage'
import SuccessPage from './SuccessPage'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import axios from 'axios'

const CREATE_ACCOUNT = 'CREATE_ACCOUNT'
const CHOOSE_ROLE = 'CHOOSE_ROLE'
const CREATE_ORGANIZATION = 'CREATE_ORGANIZATION'
const CONTACT_DETAILS = 'CONTACT_DETAILS'
const AGREEMENTS = 'AGREEMENTS'
const SUCCESS = 'SUCCESS'

const initialFormData = {
    step: CREATE_ACCOUNT,
    user: {
        email: '',
        password: '',
        confirmPassword: '',
    },
    selectedRole: '',
    organization: {
        name: '',
        industry: '',
        companySize: '',
        country: '',
        city: null,
        region: null,
        description: '',
        logo: null,
        website_url:'',
    },
    contactDetails: {
        firstName: '',
        lastName: '',
        title: '',
        phoneNumber: '',
        streetAddress: '',
        state: '',
        zipCode: '',
        location: '',
        resume: null,
        linkedinProfile: '',
        activeJobSeeker: '',
    },
    agreements: {
        termsAndConditions: false,
        recrutingAgreement: false,
    },
}

const SignupPage = () => {
    const [formData, setFormData] = useState(initialFormData)
    const [loading, setLoading] = useState(false)
    const [signUpError, setSignUpError] = useState(null)

    const submitData = async () => {
        const data = { ...formData }
        const payload = new FormData()
        const url = '/signup'
        payload.append('user[role]', data.selectedRole)
        payload.append('user[email]', data.user.email)
        payload.append('user[password]', data.user.password)
        payload.append('user[password_confirmation]', data.user.confirmPassword)
        payload.append('organization[name]', data.organization.name)
        payload.append(
            'organization[description]',
            data.organization.description
        )
        payload.append('organization[industry]', data.organization.industry)
        payload.append(
            'organization[company_size]',
            data.organization.companySize
        )
        payload.append('organization[country]', data.organization.country)
        payload.append('organization[region]', data.organization.region)
        payload.append('organization[city]', data.organization.city)
        payload.append('organization[website_url]', data.organization.website_url)
        if (data.organization.logo) {
            payload.append('organization[logo]', data.organization.logo)
        }
        payload.append(
            'registration[first_name]',
            data.contactDetails.firstName
        )
        payload.append('registration[last_name]', data.contactDetails.lastName)
        payload.append('registration[title]', data.contactDetails.title)
        payload.append(
            'registration[phone_number]',
            data.contactDetails.phoneNumber
        )
        payload.append(
            'registration[address]',
            data.contactDetails.streetAddress
        )
        payload.append('registration[zipcode]', data.contactDetails.zipCode)
        payload.append('registration[location]', data.contactDetails.streetAddress)
        if (data.contactDetails.resume) {
            payload.append('registration[resume]', data.contactDetails.resume)
        }
        payload.append(
            'registration[linkedin_profile_url]',
            data.contactDetails.linkedinProfile
        )
        payload.append(
            'registration[active_job_seeker]',
            data.contactDetails.activeJobSeeker
        )
        payload.append('registration[state]', data.contactDetails.state)
        const CSRF_Token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute('content')

        setLoading(true)

        axios
            .post(url, payload, {
                headers: {
                    'content-type': 'application/json',
                    'X-CSRF-Token': CSRF_Token,
                },
            })
            .then((res) => {
                setFormData((prev) => ({
                    ...prev,
                    step: SUCCESS,
                }))
                setLoading(false)
            })
            .catch((e) => {
                setSignUpError(e.message)
                setLoading(false)
            })
    }

    const displaySignupStep = (step) => {
        switch (step) {
            case CREATE_ACCOUNT:
                return (
                    <CreateAccountPage
                        formData={formData}
                        setFormData={setFormData}
                    />
                )
            case CHOOSE_ROLE:
                return (
                    <ChooseRolePage
                        formData={formData}
                        setFormData={setFormData}
                    />
                )
            case CREATE_ORGANIZATION:
                return (
                    <CreateOrganizationPage
                        formData={formData}
                        setFormData={setFormData}
                    />
                )
            case CONTACT_DETAILS:
                return (
                    <ContactDetailPage
                        formData={formData}
                        setFormData={setFormData}
                    />
                )

            case AGREEMENTS:
                return (
                    <AgreementsPage
                        formData={formData}
                        setFormData={setFormData}
                        submitData={submitData}
                        loading={loading}
                        signUpError={signUpError}
                        setSignUpError={setSignUpError}
                    />
                )
            case SUCCESS:
                return <SuccessPage />
            default:
                return null
        }
    }

    return <>{displaySignupStep(formData.step)}</>
}

export default SignupPage
