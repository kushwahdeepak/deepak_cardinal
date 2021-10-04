import React, { useState } from 'react'

import MainPanel from './MainPanel'
import InfoPanel from './InfoPanel'
import { H1, P } from './ChooseRolePage'
import Button from './Button'
import styles from './styles/Signup.module.scss';

const SuccessPage = () => {
    const [content, setContent] = useState(
        `Once your email and organization are verified, 
        you can begin posting jobs and inviting members into your organization.
        
        We look forward to facilitating your hiring process!
        `
    )

    return (
        <>
        <div className={`${styles.signUpForm}`}>
            <MainPanel>
                <H1>You’re all done!</H1>
                <P>Thanks for taking the time to fill out this information.</P>
            </MainPanel>
            <InfoPanel>
            <div className={`${styles.infopanelDiv}`}>
                <P
                    weight={'normal'}
                    dangerouslySetInnerHTML={{ __html: content }}
                ></P>
                <Button
                    style={{ alignSelf: 'flex-end', marginTop: '60px' }}
                    onClick={() => (window.location.href = '/users/sign_in')}
                >
                    Go to Dashboard
                </Button>
                </div>
            </InfoPanel>
        </div>
        </>
    )
}

export default SuccessPage
