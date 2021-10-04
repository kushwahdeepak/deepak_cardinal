import React, { useState } from 'react'
import { Formik, Form } from 'formik'
import * as Yup from 'yup'
import styled from 'styled-components'
import Alert from 'react-bootstrap/Alert'
import TextInput from './TextInput'
import Button from './Button'
import MainPanel from './MainPanel'
import InfoPanel from './InfoPanel'
import ReCAPTCHA from 'react-google-recaptcha'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import styles from './styles/Signup.module.scss';

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

const SPAN = styled.span`
    font-size: 15px;
    margin-top: -20px;
    text-align: center;
    margin-bottom: 20px;
`

const PasswordRecoveryPage = () => {
    const [captchaValue, setCaptchaValue] = useState(null)
    const [successFormSubmitting, setSuccessFormSubmitting] = useState('')

    return (
        <>
        <div className={`${styles.mainForm}`}>
            <MainPanel>
                <H1>Forgot Password</H1>
                <SPAN>
                    Enter the email associated with your account <br /> and
                    we'll send you instructions to reset your password
                </SPAN>
                {successFormSubmitting && (
                    <Alert
                        style={{ width:'auto',paddingLeft:'50px',paddingRight:'50px' }}
                        variant="success"
                        onClose={() =>
                            setSuccessFormSubmitting(null)
                        }
                        dismissible
                    >
                        {successFormSubmitting}
                    </Alert>
                )}
                <Formik
                    initialValues={{
                        email: '',
                        captcha: '',
                    }}
                    validationSchema={Yup.object({
                        email: Yup.string()
                            .email()
                            .required('Email is required'),
                        captcha: Yup.string().required(
                            'Please complete captcha to continue'
                        ),
                    })}
                    onSubmit={(values, { setSubmitting,resetForm }) => {
                        const payload = new FormData()
                        const url = '/users/password'
                        payload.append('user[email]', values.email)

                        const response = makeRequest(url, 'post', payload, {
                            contentType: 'application/json',
                            loadingMessage: 'Submitting...',
                            'X-CSRF-Token': document
                                .querySelector("meta[name='csrf-token']")
                                .getAttribute('content'),
                            createSuccessMessage: (response) =>
                                response.data.message,
                            onSuccess: (res) => {
                                setSuccessFormSubmitting(
                                    'Check your mail for further instructions.'
                                )
                                resetForm({values:''})
                                window.grecaptcha.reset();
                                setSubmitting(false)
                            },
                        })
                        setTimeout(() => {
                            setSuccessFormSubmitting('')
                        }, 5000)
                    }}
                    render={({
                        values,
                        errors,
                        handleSubmit,
                        handleChange,
                        isSubmitting,
                        setFieldValue,
                    }) => (
                        <Form className={styles.signForm}>
                            <TextInput className={styles.fullwidthInput}
                                label="Email Address"
                                name="email"
                                type="email"
                                id="email"
                                value={values.email}
                                onChange={(e) => {
                                    setFieldValue('email', e.target.value)
                                }}
                            />

                            <ReCAPTCHA  
                                sitekey='6LdoP0AbAAAAAE_NNrzWQtIh7I2gdHcBGvbwkGnm'
                                size="normal"
                                onChange={(value) => {
                                    const newValue = value || ''
                                    setFieldValue('captcha', newValue)
                                }}
                                
                            />

                            <TextInput className={styles.fullwidthInput}
                                type="text"
                                name="captcha"
                                id="captcha"
                                hidden
                                value={values.captcha}
                            />
                            <div>
                            <Button
                                type="submit"
                                className="float-right"
                                style={{ marginTop: '10px' }}
                            >
                                Send
                            </Button>
                            </div>
                        </Form>
                    )}
                ></Formik>
            </MainPanel>
            <InfoPanel>
                <div className="d-flex flex-column">
                    <P>Already have an account?</P>
                    <A href="/users/sign_in">Sign In</A>
                </div>
            </InfoPanel>
        </div>
        </>
    )
}

export default PasswordRecoveryPage
