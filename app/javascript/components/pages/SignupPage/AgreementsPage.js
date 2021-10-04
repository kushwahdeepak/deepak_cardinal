import React, { useState, useEffect } from 'react'
import styled from 'styled-components'

import MainPanel from './MainPanel'
import InfoPanel from './InfoPanel'
import Button from './Button'
import { RoleButton, H1, P } from './ChooseRolePage'
import { A } from './ContactDetailPage'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import Spinner from 'react-bootstrap/Spinner'
import Alert from 'react-bootstrap/Alert'
import styles from './styles/Signup.module.scss'

const CONTACT_DETAILS = 'CONTACT_DETAILS'

const Input = styled.input`
    background: #ffffff;
    border: 2px solid #dadfff;
    box-sizing: border-box;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    border-radius: 2px;
    margin-right: 15px;
`

const AgreementsPage = ({
    formData,
    setFormData,
    submitData,
    loading,
    signUpError,
    setSignUpError,
}) => {
    const [roleButtonId, setRoleButtonId] = useState(-1)
    const roleButtonText = [
        'Terms and Conditions',
        'Privacy Policy',
        'Recruiting Agreement',
    ]
    const [content, setContent] = useState('Click on the agreements to view details ')
    const [agreeToTermsAndPolicy, setAgreeToTermsAndPolicy] = useState(false)
    const [agreeToRecrutingAgreement, setAgreeToRecrutingAgreement] =
        useState(false)
    const [allroleDescription, setAllRoleButtonId] = useState(null)

    useEffect(() => {
        setFormData((prev) => ({
            ...prev,
            agreements: {
                termsAndConditions: agreeToTermsAndPolicy,
                recrutingAgreement: agreeToRecrutingAgreement,
            },
        }))

        const url = `/signup/contracts/role/${formData.selectedRole}`
        makeRequest(url, 'get', '', {
            loadingMessage: 'Fetching description...',
        }).then((res) => {
            if (res) {
                setAllRoleButtonId([...res.data])
            }   
        })

    }, [agreeToTermsAndPolicy, agreeToRecrutingAgreement])

    const fetchContent = (content) => {
        setContent(allroleDescription?.filter(data=>data.name === content)[0]?.content)
    }

    const disableButton = () => {
        let isDisabled = !formData.agreements.termsAndConditions
        if (
            formData.selectedRole != 'talent' &&
            !formData.agreements.recrutingAgreement
        ) {
            isDisabled = true
        }

        return isDisabled
    }

    if (loading) {
        return (
            <div className="d-flex justify-content-center align-items-center w-100 h-100">
                <Spinner animation="border" role="status">
                    <span className="sr-only">Loading...</span>
                </Spinner>
            </div>
        )
    }

    return (
        <>
        <div className={`${styles.signUpForm}`}>
            <MainPanel>
                <div style={{ maxWidth: '500px' }}>
                    <H1>
                        {formData.selectedRole[0].toUpperCase() +
                            formData.selectedRole.substring(1)}{' '}
                        Role
                    </H1>
                    <P primary>Agreementssss</P>
                    <RoleButton className={styles.roleButtons}
                        selected={roleButtonId == 0}
                        onClick={() => {
                            setRoleButtonId(0)
                            fetchContent('terms_and_conditions')
                        }}
                    >
                        Terms and Conditions
                    </RoleButton>
                    <RoleButton className={styles.roleButtons}
                        selected={roleButtonId == 1}
                        onClick={() => {
                            setRoleButtonId(1)
                            fetchContent('privacy_policy')
                        }}
                    >
                        Privacy Policy
                    </RoleButton>
                    {formData.selectedRole != 'talent' && (
                        <RoleButton className={styles.roleButtons}
                            selected={roleButtonId == 2}
                            onClick={() => {
                                setRoleButtonId(2)
                                fetchContent('recruiting_agreement')
                            }}
                        >
                            Recruiting Agreement
                        </RoleButton>
                    )}

                    <Input
                        type="checkbox"
                        name="terms_and_policy"
                        id="terms_and_policy"
                        value="I agree to the terms and conditions & privacy policy"
                        checked={agreeToTermsAndPolicy}
                        onChange={(e) =>
                            setAgreeToTermsAndPolicy(e.target.checked)
                        }
                    />
                    <label htmlFor="terms_and_policy">
                        {' '}
                        I agree to the terms and conditions & privacy policy
                    </label>
                    <br />
                    {formData.selectedRole != 'talent' && (
                        <>
                            <Input
                                type="checkbox"
                                name="recruting_agreement"
                                id="recruting_agreement"
                                value="I agree to the recruiting agreement"
                                checked={agreeToRecrutingAgreement}
                                onChange={(e) =>
                                    setAgreeToRecrutingAgreement(
                                        e.target.checked
                                    )
                                }
                            />
                            <label htmlFor="recruting_agreement">
                                {' '}
                                I agree to the recruiting agreement
                            </label>
                        </>
                    )}

                    <div className="float-right" style={{ marginTop: '40px' }}>
                        <A
                            style={{ marginRight: '20px' }}
                            onClick={() =>
                                setFormData((prev) => ({
                                    ...prev,
                                    step: CONTACT_DETAILS,
                                }))
                            }
                        >
                            Previous
                        </A>
                        <Button
                            type="submit"
                            disabled={disableButton()}
                            onClick={submitData}
                        >
                            Complete
                        </Button>
                    </div>
                    {signUpError && (
                        <Alert
                            variant="danger"
                            onClose={() => setSignUpError(null)}
                            dismissible
                            style={{ marginTop: '100px' }}
                        >
                            {signUpError}
                        </Alert>
                    )}
                </div>
            </MainPanel>
            <InfoPanel>
            <div className={`${styles.infopanelDiv}`}>
                <H1 size={26} lineHeight={36}>
                    {roleButtonText[roleButtonId] || 'Note'}
                </H1>
                {roleButtonId == 2 && (
                    <A
                        style={{ marginBottom: '10px', marginTop: '-25px' }}
                        target="_blank"
                        href={`/signup/contracts/download?name=recruiting_agreement&role=${formData.selectedRole}`}
                    >
                        Download PDF
                    </A>
                )}
                <div
                    style={{
                        border: '1px solid #BFC5E2',
                        width: '100%',
                        marginBottom: '30px',
                    }}
                ></div>
                <P
                    weight={'normal'}
                    dangerouslySetInnerHTML={{ __html: content }}
                    style={{
                        maxHeight: '500px',
                        overflowY: 'auto',
                    }}
                ></P>
                </div>
            </InfoPanel>
            </div>
        </>
    )
}

export default AgreementsPage
