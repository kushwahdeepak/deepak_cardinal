import React, { useState } from 'react'
import { Formik } from 'formik'
import * as Yup from 'yup'

import { H1, A, StyledForm } from './styles/UserManagementEditPage.styled'
import TextInput from './shared/TextInput'
import Button from '../SignupPage/Button'
import SelectRole from './shared/Select'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import { Row, Col } from 'react-bootstrap'
import FileButton from '../SignupPage/FileButton'

const UserManagementEditPage = ({ user }) => {
    const [resume, setResume] = useState(user.resume)
    const [resumeError, setResumeError] = useState(null)
    const [selectRole,setSelectRole] = useState(user.role)

    const saveUser = async (newUser) => {
        const formData = new FormData()
        for (var key in newUser) {
            formData.append(`person[${key}]`, newUser[key])
        }
        formData.append('person[email_address]', newUser['email'])

        if (user.resume) { formData.delete('person[resume]') }

        const url = `/admin/user/${user.id}`

        const response = await makeRequest(url, 'put', formData, {
            contentType: 'multipart/form-data',
            loadingMessage: 'Submitting...',
            onSuccess: (response) => {
              if(response.data.message_type == 'success'){
                window.location.href = '/admin/users'
              }},
            createResponseMessage: (response) => {
              return {
                  message: response.message,
                  messageType: response.message_type,
                  loading: false,
                  autoClose: true,
              }
            },
        })


    }
    const onRoleChange = (event) => {
        setSelectRole(event.target.value)
    }

    return (
        <div className="d-flex flex-column align-items-center justify-content-center mx-5 my-5">
            <H1>Update user</H1>
            <Formik
                initialValues={{
                    email: user.email || '',
                    role: user.role || '',
                    firstName: user.first_name || '',
                    lastName: user.last_name || '',
                    linkedinProfile: user.linkedin_profile_url || '',
                    phoneNumber: user.phone_number || ''
                  
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
                    linkedinProfile: Yup.string()
                        .typeError('Invalid url, please add Linkedin url only')
                        .test(
                            'linkedin only',
                            'Invalid url, please add Linkedin url only',
                            function (value) {
                                try {
                                    if(selectRole !== "talent"){
                                        return true
                                    }
                                    return (
                                        new URL(value).hostname ===
                                        'www.linkedin.com'
                                    )
                                } catch (error) {
                                    return false
                                }
                            }
                        ),
                    phoneNumber: Yup.number()
                        .typeError(
                            'Invalid Phone number, please add numbers only'
                        )
                        .test(
                            'phone number digits only',
                            'Phone number must contain 10 digits only',
                            function (value) {
                                if (!value) return true
                                const regex = /^\d{10}$/g
                                return regex.test(value)
                            }
                        ),
                    activeJobSeeker: Yup.array().length(
                        1,
                        'Please select only one checkbox'
                    ),
                })}
               
                onSubmit={(values) => {
                    saveUser({
                        first_name: values.firstName,
                        last_name: values.lastName,
                        linkedin_profile_url: values.linkedinProfile,
                        phone_number: values.phoneNumber,
                        email: values.email,
                        role: selectRole,
                    })
                }}
            >
                <StyledForm>
                    <Row>
                        <Col lg={2}></Col>
                        <Col xs={12} sm={12} lg={8}>
                            <H1>User Details</H1>
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
                                label="Email*"
                                name="email"
                                type="email"
                                id="email"
                                width="100%"
                            />
                            <SelectRole
                                label="Role"
                                name="role"
                                width="100%"
                                disabled={user.role === 'admin'}
                                value={selectRole}
                                onChange={onRoleChange}
                            >
                                <option value="">Select a role</option>
                                <option value="talent">Talent</option>
                                <option value="employer">Employer</option>
                                <option value="recruiter">Recruiter</option>
                                <option value="guest">Guest</option>
                                <option value="admin">Admin</option>
                            </SelectRole>
                            {selectRole && selectRole === 'talent' && (
                            <TextInput
                                label="Linkedin profile*"
                                name="linkedinProfile"
                                type="text"
                                id="linkedinProfile"
                                width="100%"
                            />
                            )}
                            <TextInput
                                label="Phone number"
                                name="phoneNumber"
                                type="text"
                                id="phoneNumber"
                                width="100%"
                            />
                            
                        </Col>
                    </Row>
                    <Row>
                        <Col lg={2}></Col>
                        <Col lg={8}>
                            <div style={{ marginTop: '18px' }}>
                                <Button type="submit" className="mr-sm-3 mt-2">
                                    Update
                                </Button>
                                <Button
                                    type="button"
                                    onClick={() => window.history.back()}
                                    className="ml-sm-3 mt-2"
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

export default UserManagementEditPage
