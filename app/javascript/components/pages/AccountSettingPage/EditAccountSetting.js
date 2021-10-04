import React, { Fragment } from 'react'
import { Formik } from 'formik'
import * as Yup from 'yup'

import Input from '../../common/Styled components/Input'
import { Row, W3text, Typography } from './styles/AccountSettingPage.styled'
import styles from './styles/AccountSettingPage.module.scss'

const Schema = Yup.object({
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

    linkedinProfileUrl: Yup.string()
        .required('Linkedin Profile is required')
        .nullable(true)
        .test(
            'linkedin only',
            'Invalid url, please add Linkedin url only',
            function (value) {
                try {
                    return new URL(value).hostname === 'www.linkedin.com'
                } catch (error) {
                    return false
                }
            }
        ),
    phoneNumber: Yup.string()
        .typeError('Invalid Phone number, please add numbers only')
        .required('Phone number is required')
        .nullable(true)
        .test(
            'phone number digits only',
            'Phone number must contain 10 digits only',
            function (value) {
                const regex = /^\d{10}$/g
                return regex.test(value)
            }
        ),
})

function EditAccountSetting(props) {
    const {
        firstName,
        lastName,
        email,
        handleSaveBasic,
        phoneNumber,
        linkedinProfileUrl,
        role
    } = props
    return (
        <>
            <Formik
                initialValues={{
                    firstName: firstName,
                    lastName: lastName,
                    phoneNumber: phoneNumber,
                    linkedinProfileUrl: linkedinProfileUrl,
                }}
                validationSchema={Schema}
                onSubmit={(values, { setSubmitting }) => {
                    setTimeout(() => {
                        setSubmitting(false)
                    }, 500)

                    handleSaveBasic(values)
                }}
            >
                {(props) => {
                    const {
                        values,
                        touched,
                        errors,
                        isSubmitting,
                        handleChange,
                        handleSubmit,
                    } = props
                    return (
                        <Fragment>
                            <Row aItems="center">
                                <label>Full Name</label>
                                <Input
                                    type="text"
                                    value={values.firstName}
                                    onChange={handleChange}
                                    name="firstName"
                                    width="40%"
                                    error={
                                        Boolean(errors.firstName) &&
                                        touched.firstName
                                    }
                                />
                                {errors.firstName && touched.firstName && (
                                    <Typography>{errors.firstName}</Typography>
                                )}
                            </Row>
                            <Row aItems="center">
                                <label>Last Name</label>
                                <Input
                                    type="text"
                                    value={values.lastName}
                                    onChange={handleChange}
                                    name="lastName"
                                    width="40%"
                                    error={
                                        Boolean(errors.lastName) &&
                                        touched.lastName
                                    }
                                />
                                {errors.lastName && touched.lastName && (
                                    <Typography>{errors.lastName}</Typography>
                                )}
                            </Row>

                            <Row aItems="center">
                                <label>Email</label>
                                <p style={{ marginRight: '20px' }}>
                                    {email + '    '}{' '}
                                </p>
                                <W3text color="#5F73D9" size="">
                                    {' '}
                                    (We do not currently support changing email
                                    address){' '}
                                </W3text>
                            </Row>
                            {role === 'talent' && (
                                <>
                                    <Row aItems="center">
                                        <label>Linkedin profile</label>
                                        <Input
                                            type="text"
                                            value={values.linkedinProfileUrl}
                                            onChange={handleChange}
                                            name="linkedinProfileUrl"
                                            width="40%"
                                            error={
                                                Boolean(
                                                    errors.linkedinProfileUrl
                                                ) && touched.linkedinProfileUrl
                                            }
                                        />
                                        {errors.linkedinProfileUrl &&
                                            touched.linkedinProfileUrl && (
                                                <Typography>
                                                    {errors.linkedinProfileUrl}
                                                </Typography>
                                            )}
                                    </Row>
                                </>
                            )}
                            <Row aItems="center">
                                <label>Phone Number</label>
                                <Input
                                    type="number"
                                    value={values.phoneNumber}
                                    onChange={handleChange}
                                    name="phoneNumber"
                                    width="40%"
                                    error={
                                        Boolean(errors.phoneNumber) &&
                                        touched.phoneNumber
                                    }
                                />
                                {errors.phoneNumber && touched.phoneNumber && (
                                    <Typography>
                                        {errors.phoneNumber}
                                    </Typography>
                                )}
                            </Row>
                            <Row aItems="center">
                                <button
                                    className={`${styles.editButton}`}
                                    onClick={handleSubmit}
                                >
                                    Save Changes
                                </button>
                            </Row>
                        </Fragment>
                    )
                }}
            </Formik>
        </>
    )
}

export default EditAccountSetting
