import React, { useState, useEffect } from 'react'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import ImportJobsModal from '../../common/ImportJobsModal/ImportJobsModal'
import { nanoid } from 'nanoid'
import axios from 'axios'
import { Alert, Spinner } from 'react-bootstrap'
import './styles/JobsNewPage.scss'
import AddCompanyLogo from '../../common/AddCompanyLogo/AddCompanyLogo'
import LocationAutocomplete from '../../common/LocationAutocomplete/LocationAutocomplete'
import CustomRichTextarea from '../../common/inputs/CustomRichTextarea/CustomRichTextarea'
import styles from './JobsNewPage.module.scss'
import validator from 'validator'

const formLabelsData = [
    {
        fieldLabel: 'Company Name',
        fieldType: 'text',
        fieldRequired: true,
        fieldId: nanoid(),
        controlName: 'companyName',
    },
    {
        fieldLabel: 'Title',
        fieldType: 'text',
        fieldRequired: true,
        fieldId: nanoid(),
        controlName: 'title',
    },
    {
        fieldLabel: 'Description',
        fieldType: 'textarea',
        fieldRequired: true,
        fieldId: nanoid(),
        customStyles: { minHeight: '140px', resize: 'none' },
        controlName: 'description',
    },
    {
        fieldLabel: 'Compensation',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'compensation',
    },
    {
        fieldLabel: 'Location',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'location',
    },
    {
        fieldLabel: 'Skills (should be separated by comma)',
        fieldType: 'textarea',
        fieldRequired: false,
        fieldId: nanoid(),
        customStyles: { minHeight: '80px', resize: 'none' },
        controlName: 'skills',
    },
    {
        fieldLabel: 'Requirements (should be separated by comma)',
        fieldType: 'textarea',
        fieldRequired: false,
        fieldId: nanoid(),
        customStyles: { minHeight: '80px', resize: 'none' },
        controlName: 'requirements',
    },
    {
        fieldLabel: 'Preferred Skills (should be separated by comma)',
        fieldType: 'textarea',
        fieldRequired: false,
        fieldId: nanoid(),
        customStyles: { minHeight: '80px', resize: 'none' },
        controlName: 'preferredSkills',
    },
    {
        fieldLabel: 'Benefits (should be separated by comma)',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'benefits',
    },
    {
        fieldLabel: 'Preferred Companies of Candidates',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'preferredCompaniesOfCandidates',
    },
    {
        fieldLabel: 'Preferred Education of Candidates',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'preferredEducationOfCandidates',
    },
    {
        fieldLabel: 'Preferred  Years of Experience',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'preferredYearsOfExperience',
    },
]

const JobsNewPage = ({ organizations }) => {
    const default_organization =
        organizations ? organizations.id : ''
    const [showModal, setShowModal] = useState(false)
    const [loading, setLoading] = useState(false)
    const [formInvalid, setFormInvalid] = useState(true)
    const [success, setSuccess] = useState(false)
    const [errorText, setErrorText] = useState('')
    const [formContent, setFormContent] = useState({
        companyName: '',
        title: '',
        description: '',
        compensation: '',
        location: '',
        organization: default_organization,
        skills: '',
        requirements: '',
        preferredSkills: '',
        benefits: '',
        preferredCompaniesOfCandidates: '',
        preferredEducationOfCandidates: '',
        preferredYearsOfExperience: '',
        companyLogo: null,
    })

    const handleModalClose = () => {
        setShowModal(false)
    }
    const handleModalShow = () => {
        setShowModal(true)
    }

    const submitNewJobForm = async (event) => {
        event.preventDefault()
        if (formInvalid) {
            throw new Error('Form invalid')
        }
        const payload = {
            skills: formContent.skills,
            name: formContent.title,
            description: formContent.description.replace(/<[^>]*>/g, ''),
            organization_id: formContent.organization,
            compensation: formContent.compensation,
            gen_reqs: formContent.requirements,
            portalcity: formContent.location,
            portalcompanyname: formContent.companyName,
            pref_skills: formContent.preferredSkills,
            benefits: formContent.benefits,
            experience_years: Number(formContent.preferredYearsOfExperience),
            company_names: formContent.preferredCompaniesOfCandidates,
            school_names: formContent.preferredEducationOfCandidates,
            location_id:
                formContent.location != '' ? [formContent.location] : [],
        }

        if (formContent.companyLogo) payload['logo'] = formContent.companyLogo

        var form_data = new FormData()
        for (var key in payload) {
            form_data.append(`job[${key}]`, payload[key])
        }

        const CSRF_Token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute('content')
        setLoading(true)

        try {
            const response = await axios.post('/jobs.json', form_data, {
                headers: {
                    'content-type': 'multipart/form-data',
                    'X-CSRF-Token': CSRF_Token,
                },
            })
            if (!Object.keys(response.data).includes('error')) {
                setSuccess(true)
                setTimeout(() => {
                    window.location.href = '/employer_home'
                }, 2000)
            } else {
                setSuccess(false)
                setErrorText(response.data.error)
            }
            setLoading(false)
        } catch (e) {
            console.log(e.message, 'error')
            setLoading(false)
            setErrorText('An error occurred: ', e.message)
        }
    }
    const handleInputField = (event, controlName) => {
        let value = event.target.value
        if(controlName == 'description'){
            const regex = /(<([^>]+)>)/ig;
            const value1 = value;
            if(value1.replace(regex, '') == ''){
                value = value1.replace(regex, '')
            }
        }
        setFormContent((prevState) => ({
            ...prevState,
            [controlName]: value,
        }))
    }

    useEffect(() => {
        const valid = !(
            formContent.companyName.length && (validator.trim(formContent.companyName)) &&
            formContent.title.length && (validator.trim(formContent.title)) &&
            formContent.description.length && (validator.trim(formContent.description)) &&
            formContent.organization
        )
        setFormInvalid(valid)
    }, [
        formContent.companyName,
        formContent.title,
        formContent.description,
        formContent.organization,
    ])

    const renderFormField = ({
        fieldType,
        fieldLabel,
        fieldRequired,
        fieldId,
        controlName,
        customStyles = {},
    }) => {
        if (controlName === 'location')
            return (
                <LocationAutocomplete
                    key={fieldId}
                    getLocationId={(locationId) => {
                        setFormContent((prevState) => ({
                            ...prevState,
                            [controlName]: locationId,
                        }))
                    }}
                />
            )
        return (
            <div className="new-job-form__form-group" key={fieldId}>
                <Row>
                    <Col xs={4}>
                        <label htmlFor={fieldId} className="new-job-form__label">
                            <span
                                className={`new-job-form__field-title ${
                                    fieldRequired ? 'required-title' : ''
                                }`}
                            >
                                {fieldLabel}
                            </span>
                        </label>
                    </Col>
                    <Col xs={8}>
                        {fieldType === 'text' && (
                            <input
                                required={fieldRequired}
                                className={styles.placeholderText}
                                type="text"
                                id={fieldId}
                                onChange={(event) =>
                                    handleInputField(event, controlName)
                                }
                            />
                        )}
                        {fieldType === 'textarea' ? (
                            controlName === 'description' ? (
                                <CustomRichTextarea
                                    handleContentChange={(value) =>
                                        handleInputField(
                                            { target: { value } },
                                            controlName
                                        )
                                    }
                                    styles={{
                                        border: '1px solid #6c6c6c',
                                        textTransform: 'none',
                                    }}
                                />
                            ) : (
                                <textarea
                                    style={customStyles}
                                    className={styles.placeholderText}
                                    onChange={(event) =>
                                        handleInputField(event, controlName)
                                    }
                                />
                            )
                        ) : null}
                        {fieldType === 'dropdown' && (
                            <select
                                className={styles.placeholderText}
                                onChange={(event) =>
                                    handleInputField(event, controlName)
                                }
                            >
                                {organizations &&
                                    organizations.map((org, i) => {
                                        return (
                                            <option value={org.id} key={org.id}>
                                                {org.name}
                                            </option>
                                        )
                                    })}
                            </select>
                        )}
                    </Col>
                </Row>
            </div>
        )
    }

    return (
        <div className="jobs-new-page">
            {!errorText && !success && !loading && (
                <div className="container">
                    <div className="row">
                        <div className="col-12">
                            <form className="new-job-form">
                                <div className={styles.containers}>
                                    <Row className={styles.titleRow}>
                                        <Col xs={4}>
                                            <p className={styles.recommendedJobsTitle}>
                                                <span>Add New Job</span>
                                            </p>
                                        </Col>
                                        <Col xs={6}>
                                            <Row>
                                                <Col>
                                                <button
                                                    className={styles.formButton}
                                                    style={{float:"right"}}
                                                        onClick={handleModalShow}
                                                    >
                                                        <span>Import Jobs</span>
                                                    </button>
                                                    <span className={styles.displayResults} style={{float:"right",margin:"5px"}}>
                                                        Have too many jobs to enter manually?{' '}
                                                        <br />
                                                        We can import your jobs for you.
                                                    </span>
                                                    <ImportJobsModal
                                                        handleModalClose={handleModalClose}
                                                        showModal={showModal}
                                                        organization_id={default_organization}
                                                        setShowModal={setShowModal}
                                                    />
                                                </Col>
                                            </Row>
                                        </Col>
                                    </Row>
                                    <div className="new-job-form__content">
                                       
                                        {formLabelsData.map((formItem) =>
                                            renderFormField(formItem)
                                        )}
                                        <div className="new-job-form__form-group">
                                            <AddCompanyLogo
                                                getCompanyLogo={(logo) =>
                                                    setFormContent(
                                                        (prevState) => ({
                                                            ...prevState,
                                                            companyLogo: logo,
                                                        })
                                                    )
                                                }
                                            />
                                        </div>
                                    </div>
                                    <button
                                        type="submit"
                                        className={styles.formButton}
                                        style={{float:"right"}}
                                        disabled={formInvalid}
                                        onClick={(event) =>
                                            submitNewJobForm(event)
                                        }
                                    >
                                        <span>Submit</span>
                                    </button>
                                    <br/>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            )}

            {!loading && !errorText && success && (
                <h3
                    className="p-4 process-info-title"
                    style={{ textAlign: 'center' }}
                >
                    Job posted!
                </h3>
            )}

            {!loading && errorText && !success && (
                <Alert
                    variant="danger"
                    onClose={() => setErrorText(null)}
                    dismissible
                >
                    {errorText}
                </Alert>
            )}
            {loading && (
                <div className="p-4 job-posting-message-container">
                    <Spinner animation="border" role="status">
                        <span className="sr-only">Posting job...</span>
                    </Spinner>
                    <span style={{ fontSize: '2rem', marginTop: '1rem' }}>
                        Posting job...
                    </span>
                </div>
            )}
        </div>
    )
}

export default JobsNewPage
