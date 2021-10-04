import React, { useState, useEffect } from 'react'
import { Formik, Form } from 'formik'
import * as Yup from 'yup'
import styled from 'styled-components'

import TextInput from './TextInput'
import Button from './Button'
import MainPanel from './MainPanel'
import InfoPanel from './InfoPanel'
import axios from 'axios'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
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
    color: #8091e7;
`

const SPAN = styled.span`
    font-size: 16px;
    margin-top: 10px;
    color: #1d2447;
`

const DIVERROR = styled.div`
    font-size: 15px;
    color: red;
    text-align: center;
    width: 100%;
`

const DIVSUCCESS = styled.div`
    font-size: 15px;
    color: green;
    text-align: center;
`

const initialFormData = {
    user: {
        email: '',
        password: '',
    },
}

const SigninPage = () => {
    const [formData, setFormData] = useState(initialFormData)
    const [resendMessage, setResendMessage] = useState(false)
    const resendConfirmation = () => {
        const resendformData = new FormData()
        resendformData.append(`user[email]`, formData.user.email)
        const url = `/resend_confirmation`
        makeRequest(url, 'post', resendformData, {
            contentType: 'application/json',
            loadingMessage: 'Submitting...',
            createSuccessMessage: () => 'Recruiter member added successfully',
            createErrorMessage: (e) => e.response.data.msg,
            onSuccess: () => {
                setTimeout(() => {
                    window.location.reload()
                }, 2000)
            },
        })
    }

    return (
        <>
        <div className={`${styles.mainForm}`}>
            <MainPanel>
                <H1>Sign In</H1>

                <Formik
                    initialValues={{
                        user: {
                            email: '',
                            password: '',
                        },
                    }}
                    onSubmit={(values, { setSubmitting }) => {
                        setResendMessage(false)
                        document.getElementById(
                            'signin-success-msg'
                        ).innerHTML = ''
                        document.getElementById('signin-error-msg').innerHTML =
                            ''
                        setFormData((prev) => ({
                            ...prev,
                            user: {
                                email: values.email,
                                password: values.password,
                            },
                        }))
                        const data = { ...formData }
                        const payload = new FormData()
                        const url = '/users/sign_in'
                        payload.append('user[email]', values.email)
                        payload.append('user[password]', values.password)
                        payload.append('format', 'js')
                        axios
                            .post(url, payload)
                            .then(function (response) {
                                document.getElementById(
                                    'signin-success-msg'
                                ).innerHTML =
                                    'Logged in successfully. <br /> You will be redirected in 2 seconds'
                                setTimeout(() => {
                                    window.location = '/'
                                }, 2000)
                                localStorage.setItem('user', JSON.stringify(response.data));
                            })
                            .catch(function (error) {
                                const message = error?.response?.data?.alert || 'Sorry, something went wrong.'
                                if(message === 'You have to confirm your email address before continuing.'){
                                    setResendMessage(true)
                                }
                                document.getElementById(
                                    'signin-error-msg'
                                ).innerHTML = message
                            })
                    }}
                >
                    <Form className={styles.signForm}>
                        <DIVERROR id="signin-error-msg"></DIVERROR>
                        {
                            resendMessage && <DIVERROR><a href="#" onClick={()=>resendConfirmation()}>Click here to resend confirmation </a></DIVERROR>
                        }
                        <br />

                        <DIVSUCCESS id="signin-success-msg"></DIVSUCCESS>

                        <TextInput className={styles.fullwidthInput}
                            label="Email Address"
                            name="email"
                            type="email"
                            id="email"
                        />

                        <br />

                        <TextInput className={styles.fullwidthInput}
                            label="Password"
                            name="password"
                            type="password"
                            id="password"
                        />
                        <div style={{ marginTop: '10px'}}>
                            <Button className={styles.sign_in_button}
                                type="submit"
                                style={{ alignSelf: 'flex-end',float:'right' }}
                            >
                                Sign in
                            </Button>

                            <div className="d-flex flex-column">
                                <A href="/users/password/new">
                                    <SPAN>Forgot password?</SPAN>
                                </A>
                            </div>
                        </div>
                    </Form>
                </Formik>
            </MainPanel>
            <InfoPanel>
                <div className={`${styles.infopanelDiv}`}>
                    <div className="d-flex flex-column text-center">
                        <P>Don't have an account yet?</P>
                        <A href="/users/sign_up">Sign Up</A>
                    </div>
                </div>
            </InfoPanel>
        </div>
        </>
    )
}

export default SigninPage
