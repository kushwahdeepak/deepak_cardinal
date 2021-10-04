import React, { useEffect, useState } from 'react'
import { nanoid } from 'nanoid'
import './styles/CandidateProfilePage.scss'
import ProfileUploader from './ProfileUploader'
import feather from 'feather-icons'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import validator from 'validator'
import Alert from 'react-bootstrap/Alert'

const profileInputs = [
    {
        fieldLabel: 'First Name',
        fieldType: 'text',
        fieldRequired: true,
        fieldId: nanoid(),
        controlName: 'firstName',
    },
    {
        fieldLabel: 'Last Name',
        fieldType: 'text',
        fieldRequired: true,
        fieldId: nanoid(),
        controlName: 'lastName',
    },
    {
        fieldLabel: 'Email Address',
        fieldType: 'text',
        fieldRequired: true,
        fieldId: nanoid(),
        controlName: 'emailAddress',
        fieldreadOnly: true,
    },
    {
        fieldLabel: 'Current Company',
        fieldType: 'text',
        fieldRequired: true,
        fieldId: nanoid(),
        controlName: 'currentCompany',
    },
    {
        fieldLabel: 'Linkedin URL',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'linkedinUrl',
    },
    {
        fieldLabel: 'Phone Number',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'phoneNumber',
    },
    {
        fieldLabel: 'Skills (should be separated by comma)',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'skills',
    },
    {
        fieldLabel: 'School',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'education',
    },
    {
        fieldLabel: 'Degree',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'degree',
    },
    {
        fieldLabel: 'Past Companies',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'pastCompanies',
    },
    {
        fieldLabel: 'Title',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'title',
    },
    {
        fieldLabel: 'Location',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'location',
    },
    {
        fieldLabel: 'Experience Years',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'experienceYears',
    },
    {
        fieldLabel: 'Update Resume',
        fieldType: 'file',
        fieldRequired: true,
        fieldId: nanoid(),
        controlName: 'resumeFile',
    },
    ,
    {
        fieldLabel: 'Update Profile Picture',
        fieldType: 'file',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'profilePicture',
    },
]

const CandidateProfilePage = (props) => {
    const currentUser = props.currentUser
    const person = props.person
    const personId = props.person.id
    const [formContent, setFormContent] = useState({
        firstName: person.first_name || '',
        lastName: person.last_name || '',
        emailAddress: person.email_address || '',
        currentCompany: person.employer || '',
        linkedinUrl: person.linkedin_profile || '',
        phoneNumber: person.phone_number || '',
        skills: person.skills || '',
        education: person.school || '',
        degree: person.degree || '',
        pastCompanies: person.company_names || '',
        title: person.title || '',
        location: person.location || '',
        experienceYears: person.experience_years || '',
        resumeName: props.resume,
        profilePictureName: props.avatarName,
        resumeFile: null,
        profilePicture: null,
    })
    const [formInvalid, setFormInvalid] = useState(true)
    const [isSubmit, setIsSubmit] = useState(false)
    const [wrongResumeType, setWrongResumeType] = useState(null)
    const [wrongProfilePictureType, setWrongProfilePictureType] = useState(null)
    const [validationErrors, setValidationErrors] = useState([])

    useEffect(() => {
        feather.replace()
    })

    const handleInputField = (event, controlName) => {
        const value = event.target.value

        setFormContent((prevState) => ({
            ...prevState,
            [controlName]: value,
        }))
    }

    const handleFileField = (file, controlName) => {
        if (file && !checkFileTypes([file], controlName)) {
            return
        }
        const fileControlName =
            controlName == 'resumeFile' ? 'resumeName' : 'profilePictureName'

        setFormContent((prevState) => ({
            ...prevState,
            [controlName]: file,
            [fileControlName]: file ? file.name : '',
        }))
    }

    const submitProfileDataForm = async (event) => {
        event.preventDefault()
        if (formInvalid) {
            setValidationMessages()
            window.scrollTo({ top: 0, behavior: 'smooth' })
            setIsSubmit(true)
            return
        }
        const url = `/people/${personId}.json`
        const formData = new FormData()
        formData.append('person[first_name]', formContent.firstName)
        formData.append('person[last_name]', formContent.lastName)
        // formData.append('person[email_address]', formContent.emailAddress)
        formData.append('person[employer]', formContent.currentCompany)
        formData.append('person[linkedin_profile]', formContent.linkedinUrl)
        formData.append('person[phone_number]', formContent.phoneNumber)
        formData.append('person[skills]', formContent.skills)
        formData.append('person[school]', formContent.education)
        formData.append('person[degree]', formContent.degree)
        formData.append('person[company_names]', formContent.pastCompanies)
        formData.append('person[title]', formContent.title)
        formData.append('person[location]', formContent.location)
        formData.append('person[experience_years]', formContent.experienceYears)

        if (formContent.resumeFile)
            formData.append('person[resume]', formContent.resumeFile)
        if (formContent.profilePicture)
            formData.append('person[avatar]', formContent.profilePicture)

        const response = await makeRequest(url, 'put', formData, {
            contentType: 'multipart/form-data',
            loadingMessage: 'Submitting...',
            createResponseMessage: (response) => {
                return {
                    message: response.data
                        ? response.data.message
                        : 'Update successful',
                    messageType: 'success',
                    loading: false,
                    autoClose: true,
                }
            },
        })
        window.scrollTo({ top: 0, behavior: 'smooth' })
    }

    const setValidationMessages = () => {
        let errors = []
        if (
            !(
                formContent.firstName.length &&
                validator.trim(formContent.firstName)
            )
        )
            errors.push('First Name is required')
        if (
            !(
                formContent.lastName.length &&
                validator.trim(formContent.lastName)
            )
        )
            errors.push('Last Name is required')
        if (
            !(
                formContent.emailAddress.length &&
                validator.trim(formContent.emailAddress)
            )
        )
            errors.push('Email address is required')
        if (
            !(
                formContent.currentCompany.length &&
                validator.trim(formContent.currentCompany)
            )
        )
            errors.push('Current Company is required')
        if (!isPhoneValid(formContent.phoneNumber))
            errors.push('Invalid phone number format')
        if (
            currentUser.role === 'talent' &&
            !(formContent.resumeName || formContent.resumeFile)
        )
            errors.push('Resume is required')
        setValidationErrors(errors)
    }

    useEffect(() => {
        setValidationErrors([])
        if (currentUser.role === 'talent') {
            const valid = !(
                formContent.firstName.length &&
                validator.trim(formContent.firstName) &&
                formContent.lastName.length &&
                validator.trim(formContent.lastName) &&
                formContent.emailAddress.length &&
                validator.trim(formContent.emailAddress) &&
                formContent.currentCompany.length &&
                validator.trim(formContent.currentCompany) &&
                isPhoneValid(formContent.phoneNumber) &&
                (formContent.resumeName || formContent.resumeFile)
            )
            setFormInvalid(valid)
        } else {
            const valid = !(
                formContent.firstName.length &&
                validator.trim(formContent.firstName) &&
                formContent.lastName.length &&
                validator.trim(formContent.lastName) &&
                formContent.emailAddress.length &&
                validator.trim(formContent.emailAddress) &&
                formContent.currentCompany.length &&
                validator.trim(formContent.currentCompany) &&
                isPhoneValid(formContent.phoneNumber)
            )
            setFormInvalid(valid)
        }
    }, [
        formContent.firstName,
        formContent.lastName,
        formContent.emailAddress,
        formContent.currentCompany,
        formContent.resumeFile,
        formContent.phoneNumber,
    ])

    function isPhoneValid(phone_number) {
        if (phone_number === '') return true
        var phoneRegex = /^[+]{0,1}[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$/
        return phoneRegex.test(phone_number)
    }

    /**
     * Checks if all files in Array are of type .pdf, .doc, .docx, text
     * @param {Array} files - Array of files
     * @param {string} controlName - string with value resumeFile or profilePicture
     * @returns - True if all files are of above types, othervise returns False
     */
    const checkFileTypes = (files, controlName = 'resumeFile') => {
        //define message container
        let err = ''
        // list allow mime type
        const types =
            controlName === 'resumeFile'
                ? [
                      'application/msword',
                      'application/pdf',
                      'application/docx',
                      'text/plain',
                      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                  ]
                : ['image/png', 'image/jpeg']
        // loop access array
        for (var x = 0; x < files.length; x++) {
            // compare file type find doesn't matach
            if (types.every((type) => files[x].type !== type)) {
                // create error message and assign to container
                err += files[x].type + ' is not a supported format\n'
            }
        }

        if (err !== '') {
            // if message not same old that mean has error
            controlName === 'resumeFile'
                ? setWrongResumeType(err)
                : setWrongProfilePictureType(err)
            return false
        }
        controlName === 'resumeFile'
            ? setWrongResumeType(null)
            : setWrongProfilePictureType(null)
        return true
    }

    const renderFormField = (
        {
            fieldType,
            fieldLabel,
            fieldRequired,
            fieldId,
            controlName,
            fieldreadOnly,
            customStyles = {},
        },
        fieldValue
    ) => {
        return (
            <div className="candidate-profile-form__form-group" key={fieldId}>
                <label
                    htmlFor={fieldId}
                    className="candidate-profile-form__label"
                >
                    <span
                        className={`candidate-profile-form__field-title ${
                            fieldRequired ? 'required-title' : ''
                        }`}
                    >
                        {fieldLabel}
                    </span>
                    {fieldType === 'text' && (
                        <input
                            required={fieldRequired}
                            className="candidate-profile-form__input"
                            type="text"
                            id={fieldId}
                            value={fieldValue}
                            onChange={(event) =>
                                handleInputField(event, controlName)
                            }
                            style={{
                                borderColor: `${
                                    fieldRequired &&
                                    isSubmit &&
                                    fieldValue.length <= 0
                                        ? 'red'
                                        : 'black'
                                }`,
                            }}
                            readOnly={fieldreadOnly}
                        />
                    )}
                    {fieldType === 'file' && (
                        <div className="profile-uploader-container">
                            <ProfileUploader
                                onFileSelectSuccess={(file) =>
                                    handleFileField(file, controlName)
                                }
                                onFileSelectError={({ error }) => alert(error)}
                                isProfilePicture={
                                    controlName === 'profilePicture'
                                        ? true
                                        : false
                                }
                            />
                            {controlName === 'resumeFile' &&
                            formContent.resumeName ? (
                                <span className="no-file-chosen">
                                    {formContent.resumeName}
                                </span>
                            ) : controlName === 'profilePicture' &&
                              formContent.profilePictureName ? (
                                <span className="no-file-chosen">
                                    {formContent.profilePictureName}
                                    <a
                                        style={{
                                            marginLeft: '10px',
                                            cursor: 'pointer',
                                            color: '#d81815',
                                        }}
                                        onClick={() =>
                                            handleFileField(null, controlName)
                                        }
                                    >
                                        <i data-feather="x"></i>
                                    </a>
                                </span>
                            ) : (
                                <span className="no-file-chosen">
                                    No file chosen
                                </span>
                            )}
                            {controlName === 'resumeFile' && wrongResumeType && (
                                <Alert
                                    style={{
                                        marginLeft: '10px',
                                        marginBottom: '0px',
                                        paddingRight: '4rem',
                                    }}
                                    variant="danger"
                                    onClose={() => setWrongResumeType(null)}
                                    dismissible
                                >
                                    {wrongResumeType}
                                </Alert>
                            )}
                            {controlName === 'profilePicture' &&
                                wrongProfilePictureType && (
                                    <Alert
                                        style={{
                                            marginLeft: '10px',
                                            marginBottom: '0px',
                                            paddingRight: '4rem',
                                        }}
                                        variant="danger"
                                        onClose={() =>
                                            setWrongProfilePictureType(null)
                                        }
                                        dismissible
                                    >
                                        {wrongProfilePictureType}
                                    </Alert>
                                )}
                        </div>
                    )}
                </label>
            </div>
        )
    }

    const title =
        currentUser.role === 'talent'
            ? 'Candidate Profile'
            : currentUser.role === 'employer'
            ? 'Employer Profile'
            : 'Recruiter Profile'

    return (
        <div className="candidate-profile-page">
            <h1 className="page-title">{title}</h1>
            <span className="page-subtitle">
                Enter additional information so we may better match you to your
                perfect position
            </span>
            {validationErrors.length > 0 && (
                <Alert
                    variant="danger"
                    onClose={() => setValidationErrors([])}
                    dismissible
                >
                    {validationErrors.map((error, idx) => (
                        <p key={idx} className="mb-0">
                            {error}
                        </p>
                    ))}
                </Alert>
            )}
            <form className="candidate-profile-form">
                <div className="candidate-profile-form__content">
                    {profileInputs.map((formItem) => {
                        if (
                            formItem.controlName === 'resumeFile' &&
                            (currentUser.role === 'employer' ||
                                currentUser.role === 'recruiter')
                        ) {
                            formItem.fieldRequired = false
                        }
                        return renderFormField(
                            formItem,
                            formContent[formItem.controlName]
                        )
                    })}
                </div>
                <div className="candidate-profile-form__footer">
                    <button
                        type="submit"
                        className="submit-profile-data-form"
                        onClick={(event) => submitProfileDataForm(event)}
                    >
                        <span>Save Changes</span>
                    </button>
                </div>
            </form>
        </div>
    )
}

export default CandidateProfilePage
