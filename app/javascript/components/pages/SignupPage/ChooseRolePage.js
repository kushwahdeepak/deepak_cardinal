import React, { useState, useRef, useEffect } from 'react'
import styled from 'styled-components'

import MainPanel from './MainPanel'
import InfoPanel from './InfoPanel'
import Button from './Button'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import styles from './styles/Signup.module.scss';

const H1 = styled.h1`
    font-size: ${(props) => props.size || 40}px;
    line-height: ${(props) => props.lineHeight || 55}px;
    color: #393f60;
    margin-bottom: 30px;
    text-align: center;
`

const P = styled.p`
    font-weight: ${(props) => props.weight || 300};
    font-size: 24px;
    line-height: 33px;
    color: ${(props) => (props.primary ? '#1d2447' : '#9DA4C8')};
    margin-top: 20px;
    text-align: center;

    & span {
        line-height: 1.6;
    }
`

const RoleButton = styled.button`
    border: 2px solid #dadfff;
    box-sizing: border-box;
    border-radius: 10px;
    padding-top: 15px;
    padding-bottom: 15px;
    font-weight: normal;
    font-size: 22px;
    line-height: 30px;
    text-align: center;
    color: #1d2447;
    margin-bottom: 20px;
    width: 500px;
    background-color: ${(props) => (props.selected ? '#dadfff' : '#FFFFFF')};
    &:hover {
        background: #dadfff;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.05);
    }
`

const ChooseRolePage = ({ formData, setFormData }) => {
    const [roleButtonId, setRoleButtonId] = useState(-1)
    const [allroleDescription, setAllRoleButtonId] = useState(null)
    const [roleDescription, setRoleDescription] = useState(
        'Click the role to view details '
    )

    useEffect(() => {
        const url = `/signup/contracts/name/role_desc`
        makeRequest(url, 'get', '', {
            loadingMessage: 'Fetching description...',
        }).then((res) => {
            if (res) {
                setAllRoleButtonId([...res.data])
            }   
        })
    },[])   

    const nextStep = () => {
        let nextStep = ''
        let role = ''
        let newFormData = { ...formData }
        switch (roleButtonId) {
            case 1:
                nextStep = 'CREATE_ORGANIZATION'
                role = 'employer'
                newFormData = {
                    ...newFormData,
                    contactDetails: {
                        ...newFormData.contactDetails,
                        location: '',
                        resume: null,
                        linkedinProfile: '',
                        activeJobSeeker: '',
                    },
                }
                break
            case 2:
                nextStep = 'CONTACT_DETAILS'
                role = 'recruiter'
                newFormData = {
                    ...newFormData,
                    organization: {
                        name: '',
                        industry: '',
                        companySize: '',
                        location: '',
                        description: '',
                        logo: null,
                        city:null,
                        region:null
                    },
                    contactDetails: {
                        ...newFormData.contactDetails,
                        streetAddress: '',
                        zipCode: '',
                        state: '',
                        activeJobSeeker: '',
                        linkedinProfile: '',
                    },
                }
                break
            case 3:
                nextStep = 'CONTACT_DETAILS'
                role = 'talent'
                newFormData = {
                    ...newFormData,
                    organization: {
                        name: '',
                        industry: '',
                        companySize: '',
                        location: '',
                        description: '',
                        logo: null,
                        city:null,
                        region:null
                    },
                    contactDetails: {
                        ...newFormData.contactDetails,
                        streetAddress: '',
                        zipCode: '',
                        state: '',
                        location: '',
                    },
                }
                break
            default:
                nextStep = formData.step
                break
        }
        setFormData((prev) => ({
            ...newFormData,
            step: nextStep,
            selectedRole: role,
        }))
        setRoleButtonId(-1)
    }
    
    const fetchRoleDescription = (role) => {
        console.log(roleButtonId)
        setRoleDescription(allroleDescription?.filter(data=>data.role === role)[0]?.content)
    }

    return (
        <>
        <div className={`${styles.signUpForm}`}>
                <MainPanel>
                    <div style={{ maxWidth: '500px' }}>
                        <H1>What’s your role?</H1>
                        <P primary>
                            Select the role that best describes your needs
                        </P>
                        <RoleButton className={styles.roleButtons}
                            selected={roleButtonId == 1}
                            onClick={() => setRoleButtonId(1)}
                            onMouseEnter={() => fetchRoleDescription('employer')}
                        >
                            Employer
                        </RoleButton>
                        <RoleButton className={styles.roleButtons}
                            selected={roleButtonId == 2}
                            onClick={() => setRoleButtonId(2)}
                            onMouseEnter={() => fetchRoleDescription('recruiter')}
                        >
                            Recruiter
                        </RoleButton>
                        <RoleButton className={styles.roleButtons}
                            selected={roleButtonId == 3}
                            onClick={() => setRoleButtonId(3)}
                            onMouseEnter={() => fetchRoleDescription('talent')}
                        >
                            Candidate
                        </RoleButton>
                        <Button
                            className="float-right"
                            hidden={roleButtonId < 0}
                            onClick={nextStep}
                        >
                            Next
                        </Button>
                    </div>
                </MainPanel>
                <InfoPanel>
                    <div className={`${styles.infopanelDiv}`}>
                        <H1 size={26} lineHeight={36}>
                            Role Description
                        </H1>
                        <div className={styles.borderDiv}
                            style={{
                                border: '1px solid #BFC5E2',
                                width: '100%',
                                marginBottom: '30px',
                            }}
                        ></div>
                        <P
                            weight={'normal'}
                            dangerouslySetInnerHTML={{ __html: roleDescription }}
                        ></P>
                    </div>
                </InfoPanel>
            </div>
        </>
    )
}

export default ChooseRolePage
export { RoleButton, H1, P }
