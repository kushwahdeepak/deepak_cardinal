import React, { Fragment, useState } from 'react'
import { Formik } from 'formik'
import * as Yup from 'yup'
import Alert from 'react-bootstrap/Alert'

import styles from './styles/AccountSettingPage.module.scss'
import { capitalize } from '../../../utils'
import Input from '../../common/Styled components/Input'
import {
    W3text,
    Row,
    Typography,
    Wrapper,
} from './styles/AccountSettingPage.styled'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import { passwordSchema } from '../../common/ValidationSchema/PasswordSchema'

const passwordValidationSchema = Yup.object({
    currentPassword: Yup.string().required('Current Password is required'),
    ...passwordSchema
})
const AccountSecurityPage = (props) => {
    const [isSuccess, setIsSuccess] = useState(false)
    const [error, setError] = useState(false)
    const { currentUser } = props
    const { first_name, last_name } = currentUser

    const handleReset = async (data) => {
        const { password, confirmPassword, currentPassword } = data
        const payload = new FormData()
        const url = '/user/security_update'
        payload.append('user[password]', password)
        payload.append('user[password_confirmation]', confirmPassword)
        payload.append('[current_password]', currentPassword)
        await makeRequest(url, 'post', payload, {
            contentType: 'application/json',
            loadingMessage: 'Submitting...',
            onSuccess: (res) => {
                if (res.data.message === 'Invalid Password') {
                    setError(true)
                    setIsSuccess(false)
                } else {
                    setIsSuccess(true)
                    setError(false)
                }
            },
        })
    }

    // TODO
    // Need a Nav component for account setting page nav
    
    return (
        <div className="account-setting-page" style={{ display: 'flex' }}>
            <Wrapper>
                <div className={`${styles.sidebar}`}>
                    <div className={`${styles.sidebar_header}`}>
                        <p>{capitalize(`${first_name} ${last_name}`)}</p>
                    </div>
                    <a href="/account/setting">General Settings</a>
                    <a className={`${styles.active}`} href="/account/security">
                        Security & Login
                    </a>
                    <a href="/account/email_verification">Email Verification</a>
                </div>
                <div className={`${styles.containt}`} style={{ paddingBottom: '12rem' }}>
                    {error && (
                        <Alert
                            variant="danger"
                            onClose={() => setError(false)}
                            dismissible
                        >
                            Invalid Password
                        </Alert>
                    )}
                    <h3>Security & Login</h3>
                    <div className={`${styles.basicinfo}`}>
                        <h4>Change Password</h4>
                        <div className={`${styles.basicinfodetail}`}>
                            <Row>
                                {!isSuccess && <W3text color="#1D2447" size="15px">
                                    To reset your password, please enter the
                                    information below.
                                </W3text>}
                            </Row>
                        </div>
                        {isSuccess ? (
                            <Row style={{ paddingBottom: '12rem' }}>
                                <W3text color="#1D2447" size="22px">
                                    You’ve successfully changed your password.
                                </W3text>
                            </Row>
                        ) : (
                            <Formik
                                initialValues={{
                                    currentPassword: '',
                                    password: '',
                                    confirmPassword: '',
                                }}
                                validationSchema={passwordValidationSchema}
                                onSubmit={(values, { setSubmitting }) => {
                                    setTimeout(() => {
                                        setSubmitting(false)
                                    }, 500)

                                    handleReset(values)
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
                                            <div
                                                className={`${styles.basicinfodetail}`}
                                            >
                                                <Row>
                                                    <p>
                                                        <label>
                                                            Current Password
                                                        </label>
                                                    </p>
                                                    <Input
                                                        label="no-label"
                                                        value={
                                                            values.currentPassword
                                                        }
                                                        name="currentPassword"
                                                        type="password"
                                                        onChange={handleChange}
                                                        width="20rem"
                                                        error={
                                                            Boolean(
                                                                errors.currentPassword
                                                            ) &&
                                                            touched.currentPassword
                                                        }
                                                    />
                                                    {errors.currentPassword &&
                                                        touched.currentPassword && (
                                                            <Typography>
                                                                {
                                                                    errors.currentPassword
                                                                }
                                                            </Typography>
                                                        )}
                                                </Row>
                                                <Row>
                                                    <p>
                                                        <label>
                                                            New Password
                                                        </label>{' '}
                                                    </p>
                                                    <Input
                                                        label="no-label"
                                                        value={
                                                            values.password
                                                        }
                                                        name="password"
                                                        type="password"
                                                        onChange={handleChange}
                                                        width="20rem"
                                                        error={
                                                            Boolean(
                                                                errors.password
                                                            ) &&
                                                            touched.password
                                                        }
                                                    />

                                                    {errors.password &&
                                                        touched.password && (
                                                            <Typography>
                                                                {
                                                                    errors.password
                                                                }
                                                            </Typography>
                                                        )}
                                                </Row>
                                                <Row>
                                                    <p>
                                                        <label>
                                                            Re-enter New
                                                            Password
                                                        </label>{' '}
                                                    </p>
                                                    <Input
                                                        label="no-label"
                                                        value={
                                                            values.confirmPassword
                                                        }
                                                        name="confirmPassword"
                                                        type="password"
                                                        onChange={handleChange}
                                                        width="20rem"
                                                        error={
                                                            Boolean(
                                                                errors.confirmPassword
                                                            ) &&
                                                            touched.confirmPassword
                                                        }
                                                    />

                                                    {errors.confirmPassword &&
                                                        touched.confirmPassword && (
                                                            <Typography>
                                                                {
                                                                    errors.confirmPassword
                                                                }
                                                            </Typography>
                                                        )}
                                                </Row>
                                            </div>
                                            <button
                                                className={`${styles.editButton}`}
                                                onClick={handleSubmit}
                                            >
                                                Reset Password
                                            </button>
                                        </Fragment>
                                    )
                                }}
                            </Formik>
                        )}
                    </div>
                </div>
            </Wrapper>
        </div>
    )
}
export default AccountSecurityPage
