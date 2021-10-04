import React, { useState } from 'react'
import Screen1 from '../../../../assets/images/app-pass-screen1.png'
import Screen2 from '../../../../assets/images/app-pass-screen2.png'
import Screen3 from '../../../../assets/images/app-pass-screen3.png'
import Screen4 from '../../../../assets/images/app-pass-screen4.png'
import Screen5 from '../../../../assets/images/app-pass-screen5.png'
import Screen6 from '../../../../assets/images/app-pass-screen6.png'
import Form from 'react-bootstrap/Form'
import Button from 'react-bootstrap/Button'
import './styles/CreatePasswordPopup.scss'

const CreatePasswordPopup = ({ show, sendEmail, closeHandler }) => {
    const [password, setPassword] = useState('')

    return (
        <>
            {show && (
                <>
                    <div
                        onClick={closeHandler}
                        className="create-password-clickscreen"
                    ></div>
                    <div className="create-password-popup">
                        <div className="create-password-popup__content">
                            <h1 className="page-title">
                                Get Set Up to Send Emails:
                            </h1>
                            <section className="manual-section-first">
                                <h3 className="h3-title">
                                    Turn on 2-Step Verification
                                </h3>
                                <span className="step-item">
                                    1. Visit:{' '}
                                    <a
                                        href="https://myaccount.google.com/security"
                                        className="step-link"
                                        target="_blankS"
                                    >
                                        https://myaccount.google.com/security
                                    </a>
                                </span>
                                <div className="img-block">
                                    <img
                                        src={Screen1}
                                        alt=""
                                        className="reset-screen-img"
                                    />
                                </div>
                                <span className="step-item">
                                    2. Scroll down to “Signing into Google” and
                                    click “2-Step Verification”
                                </span>
                                <div className="img-block">
                                    <img
                                        src={Screen2}
                                        alt=""
                                        className="reset-screen-img"
                                    />
                                </div>
                                <span className="step-item">
                                    3. Follow Google's prompts to turn on 2-step
                                    verification
                                </span>
                            </section>
                            <section className="manual-section-second">
                                <h3 className="h3-title">
                                    Create App-Specific Password
                                </h3>
                                <span className="step-item">
                                    1. Return to the main Security page:{' '}
                                    <a
                                        href="https://myaccount.google.com/security"
                                        className="step-link"
                                        target="_blankS"
                                    >
                                        https://myaccount.google.com/security
                                    </a>
                                </span>
                                <span className="step-item">
                                    2. Scroll down to “Signing into Google” and
                                    click “App Passwords”
                                </span>
                                <div className="img-block">
                                    <img
                                        src={Screen3}
                                        alt=""
                                        className="reset-screen-img"
                                    />
                                </div>
                            </section>
                            <section className="manual-section-third">
                                <span className="step-item">
                                    3. Click on "Select app" and choose "Other
                                    (custom name)"
                                </span>
                                <div className="img-block">
                                    <img
                                        src={Screen4}
                                        alt=""
                                        className="reset-screen-img"
                                    />
                                </div>
                                <span className="step-item">
                                    4. Type in your desired custom app name and
                                    click "Generate"
                                </span>
                                <div className="img-block">
                                    <img
                                        src={Screen5}
                                        alt=""
                                        className="reset-screen-img"
                                    />
                                </div>
                                <span className="step-item">
                                    5. Enter your generated password below
                                </span>
                                <div className="img-block">
                                    <img
                                        src={Screen6}
                                        alt=""
                                        className="reset-screen-img"
                                    />
                                </div>
                                <span className="gen-pass">
                                    Enter generated password
                                </span>
                            </section>
                            <section className="manual-section-fourth">
                                <Form
                                    style={{
                                        minWidth: '75%',
                                    }}
                                    inline
                                >
                                    <Form.Group
                                        style={{ minWidth: '75%' }}
                                        controlId="formBasicPassword"
                                    >
                                        <Form.Control
                                            style={{
                                                width: '100%',
                                                marginRight: '1rem',
                                            }}
                                            type="password"
                                            placeholder="Password"
                                            onChange={(e) => {
                                                e.preventDefault()
                                                setPassword(e.target.value)
                                            }}
                                        />
                                    </Form.Group>
                                    <Button
                                        variant="primary"
                                        type="submit"
                                        onClick={(e) => {
                                            e.preventDefault()
                                            sendEmail(password)
                                        }}
                                    >
                                        Send Mails
                                    </Button>
                                </Form>
                            </section>
                        </div>
                    </div>
                </>
            )}
        </>
    )
}

export default CreatePasswordPopup
