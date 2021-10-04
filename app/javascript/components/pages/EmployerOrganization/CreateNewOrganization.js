import React, { useState, useRef, useEffect } from 'react'
import { Formik, Form } from 'formik'
import * as Yup from 'yup'
import Resizer from 'react-image-file-resizer'
import TextInput from '../SignupPage/TextInput'
import Button from '../SignupPage/Button'
import MainPanel from '../SignupPage/MainPanel'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import {InfoText, Logo, StyledForm, H1} from './styles/EditOrganization.styled'

const CreateOrganizationPage = ({ formData, setFormData, handleSubmit }) => {
    const inputRef = useRef()
    const [logo, setLogo] = useState(formData.organization.logo)
    const [logoError, setLogoError] = useState(null)
    const [logoUrl, setLogoUrl] = useState(
        logo ? URL.createObjectURL(logo) : null
    )
    const [compnanySizes, setCompnanySizes] = useState([])
    const [industries, setIndustries] = useState([])

    useEffect(() => {
        setFormData((prev) => ({
            ...prev,
            organization: {
                ...prev.organization,
            },
        }))

        const lookupsUrl = '/signup/lookups'
        makeRequest(lookupsUrl, 'get', '').then((res) => {
            setCompnanySizes([...res.data.company_sizes])
            setIndustries([...res.data.industries])
        })
    }, [logo])

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

    return (
        <>
            <MainPanel>
                <H1>Create an Organization</H1>

                <Formik
                    initialValues={{
                        name: formData.organization.name,
                        industry: formData.organization.industry,
                        companySize: formData.organization.companySize,
                        country: formData.organization.country,
                        city: formData.organization.city,
                        region: formData.organization.region,
                        description: formData.organization.description,
                        logo: formData.organization.logo,
                    }}
                    validationSchema={Yup.object({
                        name: Yup.string().required(
                            'Organization name is required'
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
                        city: Yup.string().required('City is required'),
                        region: Yup.string().required('State is required'),
                        description: Yup.string().required(
                            'About Organization is required'
                        ),
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
                                region: values.region,
                                city: values.city,
                                description: values.description,
                                logo: logo,
                            }
                        }))
                        handleSubmit({
                            organization: {
                            name: values.name,
                            industry: values.industry,
                            companySize: values.companySize,
                            country: values.country,
                            region: values.region,
                            city: values.city,
                            description: values.description,
                            logo: logo,
                        }})
                    }}
                >
                    <StyledForm>
                        <div className="d-flex">
                            <div>
                                <TextInput
                                    label="Organization Name*"
                                    name="name"
                                    type="text"
                                    id="name"
                                    width={500}
                                />
                                <TextInput
                                    as="select"
                                    label="Industry*"
                                    name="industry"
                                    type="text"
                                    id="industry"
                                    width={350}
                                >
                                    <option value="">Select</option>
                                    {industries.map(({ key, value }) => {
                                        return (
                                            <option value={key}>{value}</option>
                                        )
                                    })}
                                </TextInput>
                                <TextInput
                                    as="select"
                                    label="Organization Size*"
                                    name="companySize"
                                    type="text"
                                    id="companySize"
                                    width={140}
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
                                <TextInput
                                    label="Country*"
                                    name="country"
                                    type="text"
                                    id="country"
                                    width={160}
                                />
                                <TextInput
                                    label="State*"
                                    name="region"
                                    type="text"
                                    id="region"
                                    width={160}
                                    style={{ marginLeft: '10px' }}
                                />
                                <TextInput
                                    label="City*"
                                    name="city"
                                    type="text"
                                    id="city"
                                    width={160}
                                    style={{ marginLeft: '10px' }}
                                />
                            </div>
                            <div
                                className="d-inline-flex flex-column"
                                style={{ marginLeft: '50px' }}
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
                                    style={{ marginTop: '20px' }}
                                    type="button"
                                    onClick={() => inputRef.current.click()}
                                >
                                    Upload File
                                </Button>
                            </div>
                        </div>

                        <TextInput
                            label="About Organization*"
                            name="description"
                            type="text"
                            id="description"
                            width={700}
                        />
                        <InfoText>
                            You will be able to edit details later.
                        </InfoText>
                        <div
                            className="float-right"
                            style={{ marginTop: '18px' }}
                        >
                            <Button
                                type="submit">
                                    Submit
                            </Button>
                        </div>
                    </StyledForm>
                </Formik>
            </MainPanel>
        </>
    )
}

export default CreateOrganizationPage
