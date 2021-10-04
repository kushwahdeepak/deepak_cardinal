import React, { useState } from 'react'
import { Formik } from 'formik'
import * as Yup from 'yup'
import axios from 'axios'
import FileButton from '../../pages/SignupPage/FileButton'
import TextInput from '../../pages/SignupPage/TextInput'
import Button from '../../pages/SignupPage/Button'
import { StyledForm, Container } from './styles/CandidateForm.styled'

function CandidateDetails({
    job,
    setErrorCreatingSubmission,
    setLoading,
    setApplied,
    setapplyDate,
    setAlertApplyForJob,
    setCandidateModal,
}) {
    const [resume, setResume] = useState()
    const [resumeError, setResumeError] = useState(null)

    const candidateValidation = Yup.object({
        firstName: Yup.string()
            .required('First Name is required')
            .max(50, 'Should not be exceed 50 characters')
            .test(
                'first name alphabets only',
                'First Name can only contain alphabet characters and one space if two words',
                function (value) {
                    const regex = /^[a-zA-Z.]+(\s[a-zA-Z.]+)?$/g
                    return regex.test(value)
                }
            ),
        lastName: Yup.string()
            .required('Last Name is required')
            .max(50, 'Should not be exceed 50 characters')
            .test(
                'last name alphabets only',
                'Last Name can only contain alphabet characters and one space if two words',
                function (value) {
                    const regex = /^[a-zA-Z.]+(\s[a-zA-Z.]+)?$/g
                    return regex.test(value)
                }
            ),
        email: Yup.string()
            .email()
            .required('Email is required')
            .test(
                'email-unique',
                'This email is already in use',
                async function (value) {
                    // check if user exists with email
                    // call backend with email and see if it returns user
                    const res = await axios.get(
                        `/users/exists?email=${encodeURIComponent(value)}`
                    )
                    return !res.data.user_exists
                }
            ),
        linkedinProfile: Yup.string()
            .required('Linkedin Profile is required')
            .test(
                'linkedin only',
                'Invalid url, please add Linkedin url only',
                function (value) {
                    try {
                        let hostname = new URL(value).hostname
                        return (
                            hostname === 'linkedin.com' ||
                            hostname === 'www.linkedin.com'
                        )
                    } catch (error) {
                        return false
                    }
                }
            ),
        phoneNumber: Yup.number()
            .typeError('Invalid Phone number, please add numbers only')
            .test(
                'phone number digits only',
                'Phone number must contain 10 digits only',
                function (value) {
                    if (!value) return true
                    const regex = /^\d{10}$/g
                    return regex.test(value)
                }
            ),
        skills: Yup.string()
            .required('skills is required')
            .max(50, 'Should not be exceed 100 characters')
            
    })

    const handleSave = async (candidate) => {
        
        const payload = new FormData()
        const url = `/jobs/${job.id}/guest_person_apply`
        payload.append('candidate[first_name]', candidate.firstName)
        payload.append('candidate[last_name]', candidate.lastName)
        payload.append('candidate[email_address]', candidate.email)
        payload.append('candidate[linkedin_profile_url]',candidate.linkedinProfile)
        payload.append('candidate[phone_number]', candidate.phoneNumber)
        payload.append('candidate[skills]', candidate.skills)
        payload.append('candidate[resume]', resume)
        payload.append('candidate[school]', [])

        try {
            setLoading(true)
            setCandidateModal(false)
            const { data } = await axios.post(url, payload)

            if (data.hasOwnProperty('error')) {
                setErrorCreatingSubmission(data.error)
                setLoading(false)
            } else {
                setApplied(true)
                setLoading(false)
                setAlertApplyForJob('You successfully applied for this job!')
            }
        } catch (error) {
            setErrorCreatingSubmission(error.response.data.error)
            setLoading(false)
        }
       
         
    }
    return (
        <Container>
            <Formik
                initialValues={{
                    email: '',
                    firstName: '',
                    lastName: '',
                    linkedinProfile: '',
                    resume: resume,
                    skills: '',
                    phoneNumber: '',
                }}
                validationSchema={candidateValidation}
                validate={(values) => {
                    const errors = {}

                    if (!resume) {
                        errors.resume = 'Resume is required'
                        setResumeError(errors.resume)
                    }

                    return errors
                }}
                onSubmit={(values, { setSubmitting }) => {
                    if (!resume) {
                        setResumeError('Resume is required')
                        return
                    }
                    setTimeout(() => {
                        setSubmitting(false)
                    }, 500)

                    handleSave(values)
                }}
            >
                <StyledForm>
                    <TextInput
                        label="First Name*"
                        name="firstName"
                        type="text"
                        id="firstName"
                        width={339}
                        maxLength={50}
                        style={{ marginRight: '10px' }}
                    />
                    <TextInput
                        label="Last Name*"
                        name="lastName"
                        type="text"
                        id="lastName"
                        width={339}
                        maxLength={50}
                        style={{ marginRight: '10px' }}
                    />
                    <TextInput
                        label="Email Address*"
                        name="email"
                        type="text"
                        id="email"
                        width={339}
                        maxLength={50}
                        style={{ marginRight: '10px' }}
                    />

                    <TextInput
                        label="Phone #"
                        name="phoneNumber"
                        type="text"
                        id="phoneNumber"
                        width={339}
                        style={{ marginRight: '10px' }}
                    />

                    <TextInput
                        label="Skills (comma seprater value e.g PHP,MySql) #"
                        name="skills"
                        type="text"
                        id="skills"
                        width={339}
                        style={{ marginRight: '10px' }}
                    />

                    <TextInput
                        label="Linkedin Profile* (https//:www.linkedin.com/in/)"
                        name="linkedinProfile"
                        type="text"
                        id="linkedinProfile"
                        width={339}
                        style={{ marginRight: '10px' }}
                    />

                    <div className="d-flex align-items-center justify-content-between">
                        <FileButton
                            label="Upload Resume"
                            type="button"
                            file={resume}
                            resumeError={resumeError}
                            setResumeError={setResumeError}
                            getFile={(file) => setResume(file)}
                        />
                    </div>

                    <div className="float-right" style={{ marginTop: '18px' }}>
                        <Button type="submit">Apply</Button>
                    </div>
                </StyledForm>
            </Formik>
        </Container>
    )
}

export default CandidateDetails
