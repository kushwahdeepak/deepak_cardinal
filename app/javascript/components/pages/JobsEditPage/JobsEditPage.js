import React, { useState, useEffect } from 'react'
import ImportJobsModal from '../../common/ImportJobsModal/ImportJobsModal'
import { nanoid } from 'nanoid'
import axios from 'axios'
import { Alert, Spinner } from 'react-bootstrap'
import './styles/JobsEditPage.scss'
import AddCompanyLogo from '../../common/AddCompanyLogo/AddCompanyLogo'
import LocationAutocomplete from '../../common/LocationAutocomplete/LocationAutocomplete'
import CustomRichTextarea from '../../common/inputs/CustomRichTextarea/CustomRichTextarea'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'

const editInputs = [
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
        fieldLabel: 'Company Name',
        fieldType: 'text',
        fieldRequired: true,
        fieldId: nanoid(),
        controlName: 'companyName',
    },
    {
        fieldLabel: 'Organization',
        fieldType: 'text',
        fieldRequired: true,
        fieldId: nanoid(),
        controlName: 'organization',
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
        fieldLabel: 'Skills (should be separated by comma)',
        fieldType: 'textarea',
        fieldRequired: false,
        fieldId: nanoid(),
        customStyles: { minHeight: '80px', resize: 'none' },
        controlName: 'skills',
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
        fieldLabel: 'Preferred Years of Experience',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'preferredYearsOfExperience',
    },
]

const JobsEditPage = ( props ) => {
    const job = props.job
    const jobId = props.job.id
    const [loading, setLoading] = useState(false)
    const [formInvalid, setFormInvalid] = useState(true)
    const [success, setSuccess] = useState(false)
    const [errorText, setErrorText] = useState('')
    const [formContent, setFormContent] = useState({
        title: job.name || '',
        description: job.description || '',
        compensation: job.compensation || '',
        companyName: job.portalcompanyname || '',
        organization: job.organization_id || '',
        skills: job.skills || '',
        requirements: job.gen_reqs || '',
        preferredSkills: job.pref_skills || '',
        benefits: job.benefits || '',
        preferredCompaniesOfCandidates: job.company_names || '',
        preferredEducationOfCandidates: job.school_names || '',
        preferredYearsOfExperience: job.experience_years || '',
    })

    const submitEditJobForm = async (event) => {
        event.preventDefault()
        if (formInvalid) {
            throw new Error('Form invalid')
        }
        const url = `/jobs/${jobId}.json`
        const payload = {
            skills: formContent.skills,
            name: formContent.title,
            description: formContent.description,
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

        window.scrollTo({ top: 0, behavior: 'smooth' })

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
            const response = await axios.put(url, form_data, {
                headers: {
                    'content-type': 'multipart/form-data',
                    'X-CSRF-Token': CSRF_Token,
                },
            })

            if (!Object.keys(response.data).includes('error')) {
                setSuccess(true)
                setTimeout(() => {
                    window.location.href = `/jobs/${jobId}`
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
        const value = event.target.value

        setFormContent((prevState) => ({
            ...prevState,
            [controlName]: value,
        }))
    }

    useEffect(() => {
        const valid = !(
            formContent.companyName.length &&
            formContent.title.length &&
            formContent.description.length &&
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
        customStyles = {}},
        fieldValue
        ) => {
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
            <div className="edit-job-form__form-group" key={fieldId}>
                <label htmlFor={fieldId} className="edit-job-form__label">
                    <span
                        className={`edit-job-form__field-title ${
                            fieldRequired ? 'required-title' : ''
                        }`}
                    >
                        {fieldLabel}
                    </span>
                    {fieldType === 'text' && (
                        <input
                            required={fieldRequired}
                            className="edit-job-form__input"
                            type="text"
                            id={fieldId}
                            value={controlName==='organization' ? props.organization : fieldValue}
                            onChange={(event) =>
                                handleInputField(event, controlName)
                            }
                            readOnly={controlName==='organization' ? true : false}

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
                                fieldValue={formContent[controlName]}
                                styles={{
                                    border: '1px solid #6c6c6c',
                                    textTransform: 'none',
                                }}
                            />
                        ) : (
                            <textarea
                                style={customStyles}
                                className="edit-job-form__input edit-job-form__input--textarea"
                                onChange={(event) =>
                                    handleInputField(event, controlName)
                                }
                                value={formContent[controlName]}
                            />
                        )
                    ) : null}
                    {fieldType === 'dropdown' && (
                        <select
                            className="edit-job-form__input"
                            onChange={(event) =>
                                handleInputField(event, controlName)
                            }
                        >
                            {props.organization &&
                                <option value={job.organization_id} key={job.organization_id}>
                                    {props.organization}
                                </option>
                                })
                        </select>
                    )}
                </label>
            </div>
        )
    }
    return (
        <div className="jobs-edit-page">
            {!errorText && !success && !loading && (
                <div className="container">
                    <div className="row">
                        <h2 className="page-title">Edit Job</h2>
                        <div className="col-12">
                            <form className="edit-job-form">
                                <div className="edit-job-form__wrapper">
                                    <div className="edit-job-form__content">
                                        {editInputs.map((formItem) =>
                                            renderFormField(
                                                formItem,
                                                formContent[formItem.controlName]
                                            )
                                        )}
                                    </div>
                                    <button
                                        type="submit"
                                        className="submit-edit-job-form"
                                        disabled={formInvalid}
                                        onClick={(event) =>
                                            submitEditJobForm(event)
                                        }
                                    >
                                        <span>Submit</span>
                                    </button>
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
                    Job Updated!
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
                        <span className="sr-only">Updating job...</span>
                    </Spinner>
                    <span style={{ fontSize: '2rem', marginTop: '1rem' }}>
                        Updating job...
                    </span>
                </div>
            )}
        </div>
    )
}

export default JobsEditPage
