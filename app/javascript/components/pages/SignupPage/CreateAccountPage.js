import React from 'react'
import { Formik, Form } from 'formik'
import * as Yup from 'yup'
import styled from 'styled-components'
import axios from 'axios'

import TextInput from './TextInput'
import Button from './Button'
import MainPanel from './MainPanel'
import InfoPanel from './InfoPanel'
import { passwordSchema } from '../../common/ValidationSchema/PasswordSchema'
import styles from './styles/Signup.module.scss';

const CHOOSE_ROLE = 'CHOOSE_ROLE'

const H1 = styled.h1`
    font-size: 40px;
    line-height: 55px;
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
    font-size: 24px;
    line-height: 33px;
    text-align: center;
    color: #8091e7;
`

const CreateAccountPage = ({ formData, setFormData }) => {
    return (
        <>
        <div className={`${styles.mainForm}`}>
            <MainPanel>
                <H1>Create an Account</H1>

                <Formik
                    initialValues={{
                        email: formData.user.email,
                        password: formData.user.password,
                        confirmPassword: formData.user.password_confirmation,
                    }}
                    validationSchema={Yup.object({
                        email: Yup.string()
                            .email()
                            .required('Email is required')
                            .test(
                                'email-unique',
                                'This email is already in use',
                                async function (value) {
                                    // check if user exists with email
                                    // call backend with email and see if it returns user

                                    const res = await axios.get(`/users/exists?email=${encodeURIComponent(value)}`)
                                    return !res.data.user_exists
                                }
                            ),
                        ...passwordSchema
                    })}
                    onSubmit={(values, { setSubmitting }) => {
                        setFormData((prev) => ({
                            ...prev,
                            user: {
                                email: values.email,
                                password: values.password,
                                confirmPassword: values.confirmPassword,
                            },
                            step: CHOOSE_ROLE,
                        }))
                    }}
                >
                    <Form className={styles.signForm}>
                        <TextInput className={styles.fullwidthInput}
                            label="Email Address"
                            name="email"
                            type="text"
                            id="email"
                        />

                        <TextInput className={styles.fullwidthInput}
                            label="Password"
                            name="password"
                            type="password"
                            id="password"
                        />

                        <TextInput className={styles.fullwidthInput}
                            label="Confirm Password"
                            name="confirmPassword"
                            type="password"
                            id="confirmPassword"
                        />

                        <Button
                            type="submit"
                            className="float-right"
                            style={{ marginTop: '10px', alignSelf: 'flex-end' }}
                        >
                            Next
                        </Button>
                    </Form>
                </Formik>
            </MainPanel>
            <InfoPanel>
                <div className={`${styles.infopanelDiv}`}>
                    <div className="d-flex flex-column">
                        <P>Have an account already?</P>
                        <A href="/users/sign_in">Sign In</A>
                    </div>
                </div>
            </InfoPanel>
            </div>
        </>
    )
}

export default CreateAccountPage
