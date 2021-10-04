import React, { useEffect, useState } from 'react'
import { Formik, Form } from 'formik'
import * as Yup from 'yup'
import styled from 'styled-components'
import TextInput from '../SignupPage/TextInput'
import Button from '../SignupPage/Button'
import MainPanel from '../SignupPage/MainPanel'
import axios from 'axios'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'

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
        email: '',
        reason: '',
}

const UnsubscribePage = (props) => {
    const {id, email} = props
    const [reasons, setReasons] = useState([])
    const [formData, setFormData] = useState(initialFormData)
    useEffect(() => {
        const url = `/unsubscribe/optout/reasons`
        makeRequest(url, 'get', '').then((res) => {
            setReasons(res.data?.data)
        })
    }, [])
    return(
      <>
          <MainPanel>
              <H1>Unsubscribe</H1>

              <Formik
                initialValues={{
                    email: email,
                    reason: '',
                }}
                validationSchema={Yup.object({
                    email: Yup.string()
                        .email()
                        .required('Email is required')
                        .test(
                            'email-unique',
                            'This email is not exists',
                            async function (value) {
                                const res = await axios.get(`/users/exists?email=${encodeURIComponent(value)}`)
                                return res.data.user_exists
                            }
                        ),
                    reason: Yup.string()
                        .required('Reason is required')
                })}
                onSubmit={(values, { setSubmitting }) => {
                    document.getElementById(
                        'signin-success-msg'
                    ).innerHTML = ''
                    document.getElementById('signin-error-msg').innerHTML =''
                    const payload = new FormData()
                    const url = '/users/unsubscribe'
                    payload.append('unsubscribe[email]', values.email)
                    payload.append('unsubscribe[reason]', values.reason)
                    payload.append('format', 'js')
                    axios
                        .post(url, payload)
                        .then(function (response) {
                            document.getElementById(
                                'signin-success-msg'
                            ).innerHTML = response.data.message
                            setTimeout(() => {
                                window.location.reload()
                            }, 2000)
                        })
                        .catch(function (error) {
                            const message = error?.response?.data?.alert || 'Sorry, something went wrong.'
                            document.getElementById(
                                'signin-error-msg'
                            ).innerHTML = message
                        })
                }}
              >
                  <Form className="d-flex flex-column">
                      <DIVERROR id="signin-error-msg"></DIVERROR>

                      <br />

                      <DIVSUCCESS id="signin-success-msg"></DIVSUCCESS>

                      <TextInput
                          label="Your Email"
                          name="email"
                          type="email"
                          id="email"
                      />

                      <br />

                      <TextInput
                            as="select"
                            label="Reason to unsubscribe"
                            name="reason"
                            type="text"
                            id="reason"
                        >
                            <option value="">Select</option>
                            {reasons.map((value) => {
                                return (
                                    <option key={value} value={value}>{value}</option>
                                )
                            })}
                        </TextInput>
                      <div style={{ marginTop: '10px',textAlign:'center'}}>
                          <Button
                              type="submit"
                              style={{ alignSelf: 'flex-end' }}
                          >
                              Unsubscribe
                          </Button>
                      </div>
                  </Form>
              </Formik>
          </MainPanel>
      </>
  )
}

export default UnsubscribePage;