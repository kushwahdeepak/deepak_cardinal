import React, { useEffect, useState } from 'react'

import styles from './styles/AccountSettingPage.module.scss'
import Input from '../../common/Styled components/Input'
import { capitalize } from '../../../utils'
import {
    Row,
    W3text,
    Column,
    Box,
    Wrapper,
} from './styles/AccountSettingPage.styled'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'

const EmailVerificationPage = (props) => {
  const {currentUser} = props
  const {id, email, first_name, last_name} = currentUser

  const handleVerification = (event) => {
    event.preventDefault();
    const URL = '/account/email_verification'
    const payload = new FormData()
    payload.append('email_verification[email]', email)
    const result = makeRequest(URL, 'post', payload, {})
  }

  return(
    <div className="account-setting-page" style={{ display: 'flex' }}>
    <Wrapper>
        <div className={`${styles.sidebar}`}>
            <div className={`${styles.sidebar_header}`}>
                <p>{capitalize(`${first_name} ${last_name}`)}</p>
            </div>
            <a  href="/account/setting">
                General Settings
            </a>
            <a href="/account/security">Security & Login</a>
            <a  className={`${styles.active}`} href="/account/email_verification">Email Verification</a>
        </div>

        <div className={`${styles.containt}`}>
            <div className={`${styles.containt_email_verify}`}>
            <h3>Email verification</h3>
             <div className={`${styles.basicinfodetail}`}>
                
                <>
                  <form onSubmit={handleVerification}>
                      <Row>
                         
                            <Input
                              label="Email"
                              value={email}
                              name="email"
                              type="text"
                              width="20rem"
                              
                            />
                         
                      </Row>
                      <Row>
                         
                          <Input
                              label="no-label"
                              type="checkbox"
                              name="terms_and_policy"
                              id="terms_and_policy"
                              value="I agree to email sending terms and conditions"
                          />
                          <span className="ml-2">I agree to email sending terms and conditions</span>
                          <br />
                          
                      </Row>
                        <Row>
                                 <button
                                    className={`${styles.editButton}`}
                                >
                                    Verify Me
                                </button>
                        </Row>
                  </form>
                </>
            </div>
            </div>
        </div>
    </Wrapper>
</div>
  )
}

export default EmailVerificationPage