import React, { useState } from 'react'
import { Formik } from 'formik'
import * as Yup from 'yup'

import { H1, StyledForm } from './styles/UserManagementEditPage.styled'
import TextInput from './shared/TextInput'
import Button from '../SignupPage/Button'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import { Row, Col } from 'react-bootstrap'
import FileButton from '../SignupPage/FileButton'

const redirectToRecruiterManagement = () => {
    window.location.href = '/admin/recruiter_management'
}


const RecruiterManagementEditPage = ({ recruiter }) => {
    const [resume, setResume] = useState(recruiter.resume)
    const [resumeError, setResumeError] = useState(null)

    const save = async (newRec) => {
        const formData = new FormData()
            formData.append('user[email]', newRec.email)
            formData.append('user[first_name]', newRec.first_name)
            formData.append('user[last_name]', newRec.last_name)
            formData.append('user[location]', newRec.location)
            formData.append('user[phone_number]', newRec.phone_number)

        const url = `/recruiters/${recruiter.id}`
        const response = await makeRequest(url, 'put', formData, {
            contentType: 'application/json',
            loadingMessage: 'Submitting...',
            createSuccessMessage: (response) => response.data.message,
        })
        redirectToRecruiterManagement()
      
    }
    const approveRecruiter = async (id) => {
        const url = `/admin/recruiters/${id}/approve`
        await makeRequest(url, 'put', '', {
            createSuccessMessage: () => 'Recruiter approved successfully',
            onSuccess: () => {
                redirectToRecruiterManagement()
            },
        })
    }
    
    const rejectRecruiter = async (id) => {
        const url = `/admin/recruiters/${id}/reject`
        await makeRequest(url, 'put', '', {
            createSuccessMessage: () => 'Recruiter rejected successfully',
            onSuccess: () => {
                redirectToRecruiterManagement()
            },
        })
    }
    
    const downloadResume = () => {}

    return (
        <div className="d-flex flex-column align-items-center justify-content-center mx-5 my-5">
            <H1>Update recruiter</H1>
            <Formik
                initialValues={{
                    firstName: recruiter.first_name,
                    lastName: recruiter.last_name,
                    email: recruiter.email || '',
                    location: recruiter.location || '',
                    phoneNumber: recruiter.phone_number || '',
                    resume: recruiter.resume,
                }}
                validationSchema={Yup.object({
                    firstName: Yup.string()
                        .required('First Name is required')
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
                        .test(
                            'last name alphabets only',
                            'Last Name can only contain alphabet characters and one space if two words',
                            function (value) {
                                const regex = /^[a-zA-Z.]+(\s[a-zA-Z.]+)?$/g
                                return regex.test(value)
                            }
                        ),
                    email: Yup.string().required('Email is required'),
                    phoneNumber: Yup.number()
                        .typeError(
                            'Invalid Phone number, please add numbers only'
                        )
                        .required('Phone number is required')
                        .test(
                            'phone number digits only',
                            'Phone number must contain 10 digits only',
                            function (value) {
                                const regex = /^\d{10}$/g
                                return regex.test(value)
                            }
                        ),
                })}
                // validate={(values) => {
                //     const errors = {}

                //     if (!resume) {
                //         errors.resume = 'Resume is required'
                //         setResumeError(errors.resume)
                //     }

                //     return errors
                // }}
                onSubmit={(values) => {
                    save({
                        first_name: values.firstName,
                        last_name: values.lastName,
                        email: values.email,
                        location: values.location,
                        phone_number: values.phoneNumber,
                        resume: resume,
                    })
                }}
            >
                <StyledForm>
                    <Row>
                        <Col xs={12} sm={12} lg={8}>
                            <H1>Recruiter Details</H1>
                            <TextInput
                                label="First Name*"
                                name="firstName"
                                type="text"
                                id="firstName"
                                width="100%"
                            />
                            <TextInput
                                label="Last Name*"
                                name="lastName"
                                type="text"
                                id="lastName"
                                width="100%"
                            />
                            <TextInput
                                label="Recruiter Email*"
                                name="email"
                                type="email"
                                id="email"
                                width="100%"
                            />
                            <TextInput
                                label="Recruiter Location"
                                name="location"
                                type="location"
                                id="location"
                                width="100%"
                            />
                            <TextInput
                                label="Recruiter Phone number*"
                                name="phoneNumber"
                                type="phoneNumber"
                                id="phoneNumber"
                                width="100%"
                            />
                            {recruiter.resume ? (
                                <div>
                                    <a
                                        onClick={downloadResume}
                                        style={{ cursor: 'pointer' }}
                                    >
                                        Download resume
                                    </a>
                                </div>
                            ) : (
                                <FileButton
                                    type="button"
                                    label="Upload PDF"
                                    file={resume}
                                    resumeError={resumeError}
                                    setResumeError={setResumeError}
                                    getFile={(file) => setResume(file)}
                                />
                            )}
                        </Col>
                        <Col xs={12} sm={12} lg={4}>
                            <div style={{ textAlign:'center'}}>
                                <H1>Mark as on demand recruiter</H1>
                                <Button
                                    type="button"
                                    onClick={()=>approveRecruiter(recruiter.id)}
                                    className="ml-sm-3"
                                    variant="success"
                                >
                                    Approve
                                </Button>
                                <Button
                                    type="button"
                                    onClick={()=>rejectRecruiter(recruiter.id)}
                                    variant="danger"
                                    className="ml-sm-3"
                                >
                                    Reject
                                </Button>
                            </div>
                        </Col>
                    </Row>
                    <Row>
                        <Col>
                            <div style={{ marginTop: '18px' }}>
                                <Button type="submit">Update</Button>
                                <Button
                                    type="button"
                                    onClick={() => window.history.back()}
                                    className="ml-sm-3"
                                >
                                    Go Back
                                </Button>
                            </div>
                        </Col>
                    </Row>
                </StyledForm>
            </Formik>
        </div>
    )
}

export default RecruiterManagementEditPage
