import React, { useState, useEffect } from 'react'
import { Formik, Form } from 'formik'
import * as Yup from 'yup'
import styled from 'styled-components'

import TextInput from './TextInput'
import Button from './Button'
import MainPanel from './MainPanel'
import InfoPanel from './InfoPanel'
import FileButton from './FileButton'
import FormRadioInput from './FormRadioInput'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import styles from './styles/Signup.module.scss'

const CREATE_ORGANIZATION = 'CREATE_ORGANIZATION'
const CHOOSE_ROLE = 'CHOOSE_ROLE'

const H1 = styled.h1`
    font-size: 30px;
    line-height: 41px;
    text-align: center;
    color: #393f60;
    margin-bottom: 30px;
`

const P = styled.p`
    font-weight: normal;
    font-size: 20px;
    line-height: 27px;
    text-align: center;
    color: #1d2447;
    margin-bottom: 15px;
`

const A = styled.a`
    font-weight: 500;
    font-size: 16px;
    line-height: 22px;
    text-align: right;
    color: #8091e7;
    cursor: pointer;
`

const StyledForm = styled(Form)`
    background: #ffffff;
    box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.1);
    border-radius: 20px;
    max-width: 800px;
    width: 800px;
    padding: 40px 50px;
`

const ContactDetailPage = ({ formData, setFormData }) => {
    const [roleDescription, setRoleDescription] = useState('')
    const [resume, setResume] = useState(formData.contactDetails.resume)
    const [resumeError, setResumeError] = useState(null)
    const [states, setStates] = useState([])

    useEffect(() => {
        setFormData((prev) => ({
            ...prev,
            contactDetails: {
                ...prev.contactDetails,
                resume: resume,
            },
        }))

        const url = `/signup/contracts?name=contact_note&role=${formData.selectedRole}`
        makeRequest(url, 'get', '').then((res) => {
            setRoleDescription(res.data?.content)
        })

        const lookupsUrl = '/signup/lookups'
        makeRequest(lookupsUrl, 'get', '').then((res) => {
            setStates([...res.data.states])
        })
    }, [resume])

    const employerFields = {
        firstName: formData.contactDetails.firstName,
        lastName: formData.contactDetails.lastName,
        title: formData.contactDetails.title,
        phoneNumber: formData.contactDetails.phoneNumber,
        streetAddress: formData.contactDetails.streetAddress,
        state: formData.contactDetails.state,
        zipCode: formData.contactDetails.zipCode,
    }

    const recruiterFileds = {
        firstName: formData.contactDetails.firstName,
        lastName: formData.contactDetails.lastName,
        streetAddress: formData.contactDetails.streetAddress,
        phoneNumber: formData.contactDetails.phoneNumber,
        resume: formData.contactDetails.resume,
    }

    const candidateFields = {
        firstName: formData.contactDetails.firstName,
        lastName: formData.contactDetails.lastName,
        linkedinProfile: formData.contactDetails.linkedinProfile,
        phoneNumber: formData.contactDetails.phoneNumber,
        resume: formData.contactDetails.resume,
        activeJobSeeker: '',
    }

    const employerValidation = Yup.object({
        firstName: Yup.string()
            .required('First Name is required')
            .max(50, 'Must be exactly 50 characters')
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
            .max(50, 'Must be exactly 50 characters')
            .test(
                'last name alphabets only',
                'Last Name can only contain alphabet characters and one space if two words',
                function (value) {
                    const regex = /^[a-zA-Z.]+(\s[a-zA-Z.]+)?$/g
                    return regex.test(value)
                }
            ),
        title: Yup.string().required('Title is required'),
        phoneNumber: Yup.string()
            .typeError('Invalid Phone number, please add numbers only')
            .required('Phone number is required')
            .test(
                'phone number digits only',
                'Phone number must contain 10 digits only',
                function (value) {
                    const regex = /^\d{10}$/g
                    return regex.test(value)
                }
            ),
        streetAddress: Yup.string().required('Street Address is required'),
        state: Yup.string().required('State is required'),
        zipCode: Yup.string()
            .required('Zip Code is required')
            .test(
                'zip code digits only',
                'Zip code must contain 5 digits only',
                function (value) {
                    const regex = /^\d{5}$/g
                    return regex.test(value)
                }
            ),
    })

    const recruiterValidation = Yup.object({
        firstName: Yup.string()
            .required('First Name is required')
            .max(50, 'Must be exactly 50 characters')
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
            .max(50, 'Must be exactly 50 characters')
            .test(
                'last name alphabets only',
                'Last Name can only contain alphabet characters and one space if two words',
                function (value) {
                    const regex = /^[a-zA-Z.]+(\s[a-zA-Z.]+)?$/g
                    return regex.test(value)
                }
            ),
        streetAddress: Yup.string().required('Location is required'),
        phoneNumber: Yup.number()
            .typeError('Invalid Phone number, please add numbers only')
            .required('Phone number is required')
            .test(
                'phone number digits only',
                'Phone number must contain 10 digits only',
                function (value) {
                    const regex = /^\d{10}$/g
                    return regex.test(value)
                }
            ),
    })

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
        linkedinProfile: Yup.string()
            .required('Linkedin Profile is required')
            .test(
                'linkedin only',
                'Invalid url, please add Linkedin url only',
                function (value) {
                    try {
                        let hostname = new URL(value).hostname
                        return hostname === 'linkedin.com' || hostname === 'www.linkedin.com'
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
        activeJobSeeker: Yup.string()
        .required('Please select only one checkbox'),
    })

    return (
        <>
        <div className={`${styles.signUpForm}`}>
            <MainPanel>
                <H1>
                    {formData.selectedRole === 'employer'
                        ? 'Contact Person Details'
                        : 'Contact Details'}
                </H1>

                <Formik
                    initialValues={
                        formData.selectedRole === 'employer'
                            ? employerFields
                            : formData.selectedRole === 'recruiter'
                            ? recruiterFileds
                            : candidateFields
                    }
                    validationSchema={
                        formData.selectedRole === 'employer'
                            ? employerValidation
                            : formData.selectedRole === 'recruiter'
                            ? recruiterValidation
                            : candidateValidation
                    }
                    validate={(values) => {
                        const errors = {}

                        if (formData.selectedRole === 'talent' && !resume) {
                            errors.resume = 'Resume is required'
                            setResumeError(errors.resume)
                        }

                        return errors
                    }}
                    onSubmit={(values, { setSubmitting }) => {
                        if (formData.selectedRole === 'talent' && !resume) {
                            setResumeError('Resume is required')
                            return
                        }

                        setFormData((prev) => ({
                            ...prev,
                            contactDetails: {
                                ...prev.contactDetails,
                                ...values,
                                resume,
                            },
                            step: 'AGREEMENTS',
                        }))
                    }}
                >
                    <StyledForm className={styles.mainoragiForm}>
                        <TextInput className={styles.contactDetailInpu}
                            label="First Name*"
                            name="firstName"
                            type="text"
                            id="firstName"
                            width="345"
                            maxLength={50}
                        />
                        <TextInput className={styles.contactDetailInpu}
                            label="Last Name*"
                            name="lastName"
                            type="text"
                            id="lastName"
                            width="345"
                            maxLength={50}
                            style={{
                                marginLeft: '10px'
                            }}
                        />
                        {formData.selectedRole === 'employer' ? (
                            <>
                                <TextInput className={styles.contactDetailInpu}
                                    label="Title*"
                                    name="title"
                                    type="text"
                                    id="title"
                                    width="345"
                                    maxLength={200}
                                />
                                <TextInput className={styles.contactDetailInpu}
                                    label="Phone #*"
                                    name="phoneNumber"
                                    type="text"
                                    id="phoneNumber"
                                    width="345"
                                    style={{
                                        marginLeft: '10px'
                                    }}
                                />
                                
                            </>
                        ) : formData.selectedRole === 'recruiter' ? (
                            <>
                                <TextInput className={styles.contactDetailInpu}
                                    label="Location*"
                                    name="streetAddress"
                                    type="text"
                                    id="streetAddress"
                                    width="345"
                                />
                                <TextInput className={styles.contactDetailInpu}
                                    label="Phone #*"
                                    name="phoneNumber"
                                    type="text"
                                    id="phoneNumber"
                                    width="345"
                                    style={{
                                        marginLeft: '10px'
                                    }}
                                />
                            </>
                        ) : null}

                        {formData.selectedRole === 'employer' && (
                            <>
                                <TextInput className={styles.contactDetailInpu}
                                    label="Street Address*"
                                    name="streetAddress"
                                    type="text"
                                    id="streetAddress"
                                    width="400"
                                />
                                <TextInput className={styles.contactDetailInpu}
                                    as="select"
                                    label="State*"
                                    name="state"
                                    type="text"
                                    id="state"
                                    width="130"
                                    style={{
                                        marginLeft: '10px',
                                    }}
                                >
                                    <option value=""></option>
                                    {states.map(({ key, value }) => {
                                        return (
                                            <option key={key} value={key}>
                                                {value}
                                            </option>
                                        )
                                    })}
                                </TextInput>

                                <TextInput className={styles.contactDetailInpu}
                                    label="Zip Code*"
                                    name="zipCode"
                                    type="text"
                                    id="zipCode"
                                    width="150"
                                    style={{
                                        marginLeft: '10px',
                                    }}
                                />
                            </>
                        )}

                        {formData.selectedRole === 'recruiter' && (
                            <FileButton 
                                type="button"
                                label="Upload Resume"
                                file={resume}
                                resumeError={resumeError}
                                setResumeError={setResumeError}
                                getFile={(file) => setResume(file)}
                            />
                        )}

                        {formData.selectedRole === 'talent' && (
                            <>
                            
                                <div className={styles.uplodDiv}>
                                <div className={styles.uplodDivs}>
                                    <FileButton
                                        label="Upload Resume"
                                        type="button"
                                        width={345}
                                        file={resume}
                                        resumeError={resumeError}
                                        setResumeError={setResumeError}
                                        getFile={(file) => setResume(file)}
                                    />
                                    </div>
                                    <TextInput className={styles.formDetailswidth}
                                        label="Linkedin Profile*"
                                        name="linkedinProfile"
                                        type="text"
                                        id="linkedinProfile"
                                        width={345}
                                        style={{
                                            marginLeft: '10px',
                                        }}
                                    />
                                </div>
                                <div className={styles.phoneDiv}>
                                    <TextInput className={styles.formDetailswidth}
                                        label="Phone # (Optional)"
                                        name="phoneNumber"
                                        type="text"
                                        id="phoneNumber"
                                        width={345}
                                    />
                                    <div className={styles.formDetailscheckbox}
                                       
                                    >
                                        <p>Are you an active job seeker?</p>
                                        <FormRadioInput
                                            name="activeJobSeeker"
                                            id="activeJobSeeker"
                                            value="Yes, I am actively searching for a
                                            job"
                                        >
                                            Yes, I am actively searching for a
                                            job
                                        </FormRadioInput>
                                        <FormRadioInput
                                            name="activeJobSeeker"
                                            id="activeJobSeeker"
                                            value="No, but I am open to the right
                                            opportunity"
                                        >
                                            No, but I am open to the right
                                            opportunity
                                        </FormRadioInput>
                                        <FormRadioInput
                                            name="activeJobSeeker"
                                            id="activeJobSeeker"
                                            value="No, I am just browsing"
                                        >
                                            No, I am just browsing
                                        </FormRadioInput>
                                    </div>
                                </div>
                            </>
                        )}

                        <div
                            className="float-right"
                            style={{ marginTop: '18px' }}
                        >
                            <A
                                style={{ marginRight: '20px' }}
                                onClick={() =>
                                    setFormData((prev) => ({
                                        ...prev,
                                        step:
                                            formData.selectedRole === 'employer'
                                                ? CREATE_ORGANIZATION
                                                : CHOOSE_ROLE,
                                    }))
                                }
                            >
                                Previous
                            </A>
                            <Button type="submit">Next</Button>
                        </div>
                    </StyledForm>
                </Formik>
            </MainPanel>
            <InfoPanel>
            <div className={styles.signUpdetails}>
                <div className="d-flex flex-column">
                    <P>Note</P>
                    <div
                        style={{
                            border: '1px solid #BFC5E2',
                            width: '100%',
                            marginBottom: '30px',
                        }}
                    ></div>
                    <P
                        weight={'normal'}
                        dangerouslySetInnerHTML={{ __html: roleDescription }}
                    ></P>
                </div>
            </div>    
            </InfoPanel>
        </div>
        </>
    )
}

export default ContactDetailPage
export { A }
