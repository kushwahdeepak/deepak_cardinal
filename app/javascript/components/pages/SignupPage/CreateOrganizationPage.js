import React, { useState, useRef, useEffect } from 'react'
import { Formik, Form } from 'formik'
import * as Yup from 'yup'
import styled from 'styled-components'
import Resizer from 'react-image-file-resizer'
import axios from 'axios'
import Select from 'react-select'
import stateCities from 'state-cities'

import TextInput from './TextInput'
import Button from './Button'
import MainPanel from './MainPanel'
import InfoPanel from './InfoPanel'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import { capitalizeFirstLetter } from '../../../utils'
import styles from './styles/Signup.module.scss';

const CONTACT_DETAILS = 'CONTACT_DETAILS'
const CHOOSE_ROLE = 'CHOOSE_ROLE'

const H1 = styled.h1`
    font-size: 30px;
    line-height: 41px;
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
    font-size: 16px;
    line-height: 22px;
    text-align: right;
    color: #8091e7;
    cursor: pointer;
`

const StyledForm = styled(Form)`
    background: #ffffff;
    box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.1);
    border-radius: 20px;
    max-width: 800px;
    width: 800px;
    padding: 40px 50px;
`

const InfoText = styled.p`
    font-size: 12px;
    line-height: 16px;
    color: #828bb9;
    margin-top: -15px;
`


const Logo = styled.div`
    background: ${(props) =>
        props.image
            ? `url(${props.image}) no-repeat center center`
            : `linear-gradient(
        133.96deg,
        #ced9ff -13.41%,
        #eeeefd 51.28%,
        #ccceff 114.63%
    )`};
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    line-height: 27px;
    text-align: center;
    color: #9fabe8;
    padding: 35px 30px;
    height: 150px;
    width: 150px;
`

const CreateOrganizationPage = ({ formData, setFormData }) => {
    const [roleDescription, setRoleDescription] = useState('')
    const inputRef = useRef()
    const [logo, setLogo] = useState(formData.organization.logo)
    const [logoError, setLogoError] = useState(null)
    const [stateError, setStateError] = useState(null)
    const [cityError, setCityError] = useState(null)
    const [logoUrl, setLogoUrl] = useState(
        logo ? URL.createObjectURL(logo) : null
    )
    const [compnanySizes, setCompnanySizes] = useState([])
    const [industries, setIndustries] = useState([])
    const [states, setStates] = useState(stateCities.getStates())
    const [selectState, setSelectState] = useState(null)
    const [citys, setCitys] = useState()
    const [selectCity, setSelectCity] = useState(null)
    useEffect(() => {
        setFormData((prev) => ({
            ...prev,
            organization: {
                ...prev.organization,
            },
        }))

        const url = `/signup/contracts?name=org_note&role=${formData.selectedRole}`
        makeRequest(url, 'get', '').then((res) => {
            setRoleDescription(res.data?.content)
        })

        const lookupsUrl = '/signup/lookups'
        makeRequest(lookupsUrl, 'get', '').then((res) => {
            setCompnanySizes([...res.data.company_sizes])
            setIndustries([...res.data.industries])
        })
        let stateOption = []
        stateCities.getStates().map((value) => {
               stateOption.push({ label: capitalizeFirstLetter(value), value: capitalizeFirstLetter(value) })
        })
        setStates(stateOption)
    }, [logo])
    useEffect(() => {
        if (formData.organization.region && formData.organization.city) {
            setSelectState({
                label: formData.organization.region,
                value: formData.organization.region,
            })
            setSelectCity({
                label: formData.organization.city,
                value: formData.organization.city,
            })
        }
    }, [])

    const resizeFile = (file) =>
        new Promise((resolve) => {
            Resizer.imageFileResizer(
                file,
                150,
                150,
                'PNG',
                100,
                0,
                (uri) => {
                    resolve(uri)
                },
                'file',
                150,
                150
            )
        })

    const addLogo = async (e) => {
        e.persist()
        const compressedImage = await resizeFile(e.target.files[0])
        setLogoError(null)
        setLogo(compressedImage)
        setLogoUrl(URL.createObjectURL(compressedImage))
        setFormData((prev) => ({
            ...prev,
            organization: {
                ...prev.organization,
                logo: logo,
            },
        }))
    }
 

    const onSelectState = (event) => {
       
        setSelectCity(null)
        setSelectState(event)
        let cityOption = []
        stateCities.getCities(event.value).map((value,key)=>{
            cityOption.push({value:capitalizeFirstLetter(value),label:capitalizeFirstLetter(value)})
        })
        setCitys(cityOption)
      } 
      const onSelectCity = (event) => {
        setSelectCity(event)
      } 

    return (
        <>
        <div className={`${styles.signUpForm}`}>
            <MainPanel>
                <H1>Create an Organization</H1>

                <Formik
                    initialValues={{
                        name: formData.organization.name,
                        industry: formData.organization.industry,
                        companySize: formData.organization.companySize,
                        country: 'USA',
                        city: formData.organization.city,
                        region:formData.organization.region,
                        description: formData.organization.description,
                        logo: formData.organization.logo,
                        website_url: formData.organization.website_url,
                    }}
                    validationSchema={Yup.object({
                        name: Yup.string()
                        .max(100, 'Must be exactly 100 characters')
                        .required('Organization name is required')
                        .test(
                            'name-unique',
                            'This Organization name is already in use',
                            async function (value) {
                                // check if user exists with email
                                // call backend with email and see if it returns user

                                const res = await axios.get(`/organizations/exists?name=${encodeURIComponent(value)}`)
                                return !res.data.organization_exists
                            }
                        ),
                        industry: Yup.string()
                            .required('Industry is required')
                            .oneOf(
                                industries.map(({ key, value }) => key),
                                'Invalid Industry'
                            ),
                        companySize: Yup.string()
                            .required('Organization size is required')
                            .oneOf(
                                compnanySizes.map(({ key, value }) => key),
                                'Invalid Organization Size'
                            ),
                        country: Yup.string().required('Country is required'),
                        description: Yup.string().required(
                            'About Organization is required'
                        ),
                        website_url: Yup.string().required(
                            'Organization Website Url is required'
                        ).trim('Organization website cannot include leading and trailing spaces'),
                    })}
                    validate={(values) => {
                        const errors = {}

                        if (!logo) {
                            errors.logo = 'Logo is required'
                        } else if (
                            ![
                                'image/jpg',
                                'image/jpeg',
                                'image/gif',
                                'image/png',
                            ].includes(logo.type)
                        ) {
                            errors.logo =
                                'Logo can only ne of type jpg, png, gif, jpeg'
                        }
                        setLogoError(errors.logo)
                      
                        if(!selectState){
                            errors.region = 'State is required'
                        }
                        setStateError(errors.region)
                       
                        if(!selectCity){
                            errors.city = 'City is required'
                        }
                        setCityError(errors.city)

                        return errors
                    }}
                    onSubmit={(values, { setSubmitting }) => {
                      
                        setFormData((prev) => ({
                            ...prev,
                            organization: {
                                name: values.name,
                                industry: values.industry,
                                companySize: values.companySize,
                                country: values.country,
                                region: selectState.value,
                                city: selectCity.value,
                                description: values.description,
                                logo: logo,
                                website_url: values.website_url,
                            },
                            step: CONTACT_DETAILS,
                        }))
                    }}
                >
                    <StyledForm className={styles.createorganizationForm}> 
                        <div className={styles.form_flexDiv}>
                            <div>
                                <TextInput className={styles.fullwidthInput}
                                    label="Organization Name*"
                                    name="name"
                                    type="text"
                                    id="name"
                                    width={500}
                                    maxLength={100}
                                />
                                <div className={styles.form_flexDiv}>
                                <TextInput className={styles.fullwidthInput}
                                    as="select"
                                    label="Industry*"
                                    name="industry"
                                    type="text"
                                    id="industry"
                                    width={340}
                                >
                                    <option value="">Select</option>
                                    {industries.map(({ key, value }) => {
                                        return (
                                            <option value={key}>{value}</option>
                                        )
                                    })}
                                </TextInput>
                                <TextInput className={styles.fullwidthInput}
                                    as="select"
                                    label="Organization Size*"
                                    name="companySize"
                                    type="text"
                                    id="companySize"
                                    width={150}
                                    style={{ marginLeft: '10px' }}
                                >
                                    <option value="">Select</option>
                                    {compnanySizes.map(({ key, value }) => {
                                        return (
                                            <option key={key} value={key}>
                                                {value}
                                            </option>
                                        )
                                    })}
                                </TextInput>
                                </div>
                                <TextInput className={styles.fullwidthInput}
                                    label="Country*"
                                    name="country"
                                    type="text"
                                    id="country"
                                    width={500}
                                    readOnly="true"
                                />
                                <div className={styles.form_flexDiv}>
                                    <div className={styles.selectDiv}>
                                        <label for="state" class="sc-gtsrHT jkaNjf">State*</label>
                                            <Select
                                            options={states}  
                                            onChange={onSelectState}
                                            name="region"
                                            className={styles.colourStyles}
                                            classNamePrefix={styles.colourStyles}
                                        />
                                  </div>
                                  <div className={styles.selectDiv}>
                                        <label for="city" class="sc-gtsrHT jkaNjf" style={{marginLeft: '11px'}}>City*</label>
                                            <Select
                                            options={citys} 
                                            onChange={onSelectCity}
                                            name="city"
                                            value={selectCity}
                                            className={styles.colourStylesCity}
                                            classNamePrefix={styles.colourStylesCity}
                                        />
                                  </div>
                                </div>
                                 <div className={styles.form_flexDiv}>
                                        {(
                                            <span
                                                style={{
                                                    fontSize: '10px',
                                                    color: 'red',
                                                    marginTop: '5px',
                                                    minWidth: '27em'
                                                }}
                                            >
                                                {stateError ? stateError : ''}
                                            </span>
                                        )}

                                        {cityError && (
                                            <span
                                                style={{
                                                    fontSize: '10px',
                                                    color: 'red',
                                                    marginTop: '5px',
                                                }}
                                            >
                                                {cityError}
                                            </span>
                                        )}
                                 </div>
                                 <br></br>
                                 <TextInput className={styles.fullwidthInput}
                                    label="Organization Website URL*"
                                    name="website_url"
                                    type="text"
                                    id="website_url"
                                    width={500}
                                    maxLength={100}
                                />
                                 <TextInput className={styles.fullwidthInput}
                                    as="textarea"
                                    label="About Organization*"
                                    name="description"
                                    type="text"
                                    id="description"
                                    width={500}
                                />
                                <InfoText>
                                    You will be able to edit details later.
                                </InfoText>
                            </div>
                            <div
                                className={` ${styles.logoBox} d-inline-flex flex-column`}
                            >
                                <Logo image={logoUrl}>
                                    {logoUrl ? '' : 'Upload Organizations Logo'}
                                </Logo>

                                {logoError && (
                                    <span
                                        style={{
                                            fontSize: '10px',
                                            color: 'red',
                                            marginTop: '5px',
                                        }}
                                    >
                                        {logoError}
                                    </span>
                                )}
                                <input
                                    type="file"
                                    name="logo"
                                    id="logo"
                                    ref={inputRef}
                                    hidden
                                    onChange={addLogo}
                                />

                                <Button
                                    style={{ marginTop: '18px' }}
                                    type="button"
                                    onClick={() => inputRef.current.click()}
                                >
                                    Upload File
                                </Button>
                            </div>
                        </div>

                       
                        <div
                            className="float-right"
                            style={{ marginTop: '18px' }}
                        >
                            <A
                                style={{ marginRight: '20px' }}
                                onClick={() =>
                                    setFormData((prev) => ({
                                        ...prev,
                                        step: CHOOSE_ROLE,
                                    }))
                                }
                            >
                                Previous
                            </A>
                            <Button type="submit">Next</Button>
                        </div>
                    </StyledForm>
                </Formik>
            </MainPanel>
            <InfoPanel>
            <div className={`${styles.infopanelDiv}`}>
                <div className="d-flex flex-column">
                    <P>Note</P>
                    <div
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
                </div>
            </InfoPanel>
        </div>
        </>
    )
}

export default CreateOrganizationPage
