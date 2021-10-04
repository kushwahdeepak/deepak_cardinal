import React, { useState } from 'react'
import { Formik, Form } from 'formik'
import * as Yup from 'yup'
import styled from 'styled-components'

import TextInput from './TextInput'
import Button from './Button'
import MainPanel from './MainPanel'
import InfoPanel from './InfoPanel'
import axios from 'axios'
import { passwordSchema } from '../../common/ValidationSchema/PasswordSchema'

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

const SPAN = styled.span`
    font-size: 15px;
    margin-top: -20px;
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
    password: '',
    password_confirmation: '',
}

const PasswordChangePage = () => {
    const [formData, setFormData] = useState(initialFormData)

    return (
        <>
            <MainPanel>
                <H1>Reset Password</H1>
                <SPAN>
                    Your new password should be different from current and old
                    passwords.
                </SPAN>

                <Formik
                    initialValues={{
                        password: formData.password,
                        confirmPassword: formData.password_confirmation,
                    }}
                    validationSchema={Yup.object({
                        ...passwordSchema
                    })}
                    onSubmit={(values, { setSubmitting }) => {
                        document.getElementById(
                            'signin-success-msg'
                        ).innerHTML = ''
                        document.getElementById('signin-error-msg').innerHTML =
                            ''
                        setFormData((prev) => ({
                            ...prev,
                            user: {
                                password: values.password,
                                confirmPassword:
                                    values.confirmPassword,
                            },
                        }))
                        const data = { ...formData }
                        const payload = new FormData()
                        const url = '/users/password'
                        payload.append('user[password]', values.password)
                        payload.append(
                            'user[password_confirmation]',
                            values.confirmPassword
                        )
                        payload.append(
                            'user[reset_password_token]',
                            document.querySelector(
                                "input[id='reset_password_token']"
                            ).value
                        )
                        payload.append(
                            'user[accepts_date]',
                            document.querySelector("input[id='accepts_date']")
                                .value
                        )
                        payload.append(
                            'user[accepts]',
                            document.querySelector("input[id='accepts']").value
                        )
                        payload.append('format', 'js')
                        axios
                            .patch(url, payload)
                            .then(function (response) {
                                document.getElementById(
                                    'signin-success-msg'
                                ).innerHTML = 'Sucessfully changed password'
                                setTimeout(() => {
                                    window.location = '/'
                                }, 2000)
                            })
                            .catch(function (error) {
                                document.getElementById(
                                    'signin-error-msg'
                                ).innerHTML = 'Wrong email or password!'
                            })
                    }}
                >
                    <Form>
                        <DIVERROR id="signin-error-msg"></DIVERROR>

                        <br />

                        <DIVSUCCESS id="signin-success-msg"></DIVSUCCESS>

                        <br />

                        <TextInput
                            label="Password"
                            name="password"
                            type="password"
                            id="password"
                        />

                        <br />

                        <TextInput
                            label="Confirm Password"
                            name="confirmPassword"
                            type="password"
                            id="confirmPassword"
                        />

                        <br />

                        <Button
                            type="submit"
                            className="float-right"
                            style={{ marginTop: '10px' }}
                        >
                            Send
                        </Button>
                    </Form>
                </Formik>
            </MainPanel>
            <InfoPanel>
                <div className="d-flex flex-column">
                    <P>Already have an account?</P>
                    <A href="/users/sign_in">Sign In</A>
                </div>
            </InfoPanel>
        </>
    )
}

export default PasswordChangePage
