import React, { useRef, useState, useContext, useEffect } from 'react'
import FileUploader from './FileUploader'
import AttachmentIcon from '../../../../assets/images/icons/attachment-icon.svg'
import InsertVarIcon from '../../../../assets/images/icons/insert-var-icon.svg'
import AddLinkIcon from '../../../../assets/images/icons/add-link-icon.svg'
import axios from 'axios'
import Alert from 'react-bootstrap/Alert'
import Toast from 'react-bootstrap/Toast'
import './styles/EmailClient.scss'
import CreatePasswordPopup from '../CreatePasswordPopup/CreatePasswordPopup'
import isEmpty from 'lodash.isempty'
import { StoreDispatchContext } from '../../../stores/JDPStore'
import Dropdown from 'react-bootstrap/Dropdown'
import EmailContent from './EmailContent'
import AddLinkModal from './AddLinkModal'
import Delta from 'quill-delta'
import { Quill } from 'react-quill'
import TextareaAutosize from 'react-autosize-textarea'
import Util from '../../../utils/util'
// Tell Quill to wrap sections with <div> instead of <p>
// (otherwise you get double lines due to: <p><br></p>)
const Block = Quill.import('blots/block')
Block.tagName = 'DIV'
Quill.register(Block, true)

const EmailClient = (props) => {
    const {
        emailClientId,
        userId,
        sendList,
        jobId,
        userEmail,
        isEmailConfigured,
        showByDefault = false,
        mailSentCallback,
        embedded = false,
        candidateCount,
        title = 'New email',
        setSuccessFormSubmitting,
        successFormSubmitting
    } = props
    const initialFormState = {
        fromInput: userEmail,
        toInput: '',
        subjectInput: '',
        contentTextArea: 'Hi {{first_name}},<br>',
    }
    const [showPasswordModal, setShowPasswordModal] = useState(false)
    const [passwordSubmitted, setPasswordSubmitted] = useState(false)
    const [show, setShow] = useState(embedded)
    const [sendingMails, setSendingMails] = useState(false)
    const [uploadedFile, setUploadedFile] = useState(null)
    const [formState, setFormState] = useState(initialFormState)
    const [externalSendEmailFunc, setExternalSendEmailFunc] = useState(null)
    const [filteredRecipients, setFilteredRecipients] = useState([])
    const [recipientDisplayString, setRecipientDisplayString] = useState('')

    const [requestAssistProps, setRequestAssistProps] = useState({})

    // success/error state
    const [formErrorSubmitting, setFormErrorSubmitting] = useState('')

    // used for inserting variables into subject/content inputs
    const [
        lastUsedVariableInputField,
        setLastUsedVariableInputField,
    ] = useState('contentTextArea')
    const emailContentRef = useRef(null)
    const subjectRef = useRef(null)

    // names of 'variables' that can be inserted into document by user
    const documentVariables = ['first_name', 'last_name']
    const fieldNameToRef = {
        contentTextArea: emailContentRef,
        subjectInput: subjectRef,
    }

    const handleCloseModal = () => setShow(false)
    const handleShowModal = () => setShow(true)

    // feature flags
    const enableAddLinkButton = false
    const [showAddLinkModal, setShowAddLinkModal] = useState(false)
    const [selectedText, setSelectedText] = useState({
        selection: {},
        text: '',
    })

    const handleSendButton = async (event) => {
        event.preventDefault()

        const candidates = sendList
        const candidateIds = candidates.map((candidate) => candidate.id)

        const errors = []

        if (isEmpty(candidateIds))
            errors.push("You haven't selected any candidates to mail.")
        if (isEmpty(formState.subjectInput))
            errors.push('You must enter a subject before sending')
        if (isEmpty(formState.contentTextArea))
            errors.push('You must enter a message to send')

        if (!isEmpty(errors)) {
            setFormErrorSubmitting(errors[0])
            return
        }

        if (!isEmailConfigured && !passwordSubmitted) {
            setExternalSendEmailFunc(() => (appPassword) =>
                sendEmail(candidateIds, appPassword)
            )
            setShowPasswordModal(true)
        } else {
            sendEmail(candidateIds)
        }
    }

    const handleInsertVariable = (variable) => {
        const fieldName = lastUsedVariableInputField
        const element = fieldNameToRef[fieldName].current
        if (fieldName === 'contentTextArea') {
            const newValue = insertText(variable)
            setFormState({
                ...formState,
                [fieldName]: newValue,
            })
        } else {
            const cursorPos = element.selectionStart
            const oldText = formState[fieldName]
            setFormState({
                ...formState,
                [fieldName]:
                    oldText.slice(0, cursorPos) +
                    `{{${variable}}}` +
                    oldText.slice(cursorPos),
            })
        }
    }

    const insertText = (variable) => {
        var range = emailContentRef.current.getSelection()
        let position = range ? range.index : 0
        emailContentRef.current.insertText(
            position,
            variable ? `{{${variable}}}` : ''
        )
        return emailContentRef.current.selection.root.innerHTML
    }

    const inputChangeHandler = (event, inputType) => {
        event.preventDefault()
        const newValue = event.target.value

        setFormState({
            ...formState,
            [inputType]: newValue,
        })
    }

    const sendEmail = async (candidateIds, appPassword) => {
        setShowPasswordModal(false)

        const url = '/campaigns'
        const CSRF_Token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute('content')
        const campaign = {
            source_address: formState.fromInput,
            subject: formState.subjectInput,
            content: formState.contentTextArea,
            user_id: userId,
        }
        campaign['job_id'] = jobId ?? -1

        const email_credentials = {
            email_address: userEmail,
            password: appPassword ?? '',
        }

        setSendingMails(true)

        try {
            const payload = new FormData()

            payload.append('list_of_recipient_ids', candidateIds)
            for (var key in campaign)
                payload.append(`campaign[${key}]`, campaign[key])
            if (uploadedFile) {
                payload.append(`campaign[attachment]`, uploadedFile)
                payload.append(`campaign[attachment_name]`, uploadedFile.name)
            }
            for (var key in email_credentials)
                payload.append(`email_credentials[${key}]`, email_credentials[key])
            const result = await axios.post(url, payload, {
                headers: {
                    'content-type': 'multipart/form-data',
                    'X-CSRF-Token': CSRF_Token,
                },
            })

            const recentlyContactedRecipients = result.data
            const notAllRecipientsWereFiltered =
                recentlyContactedRecipients.length < candidateIds.length

            setFilteredRecipients(recentlyContactedRecipients)
            setPasswordSubmitted(true)
            setFormErrorSubmitting('')
            setSendingMails(false)
            setFormState(initialFormState)
            setUploadedFile(null)

            if (mailSentCallback) {
                mailSentCallback()
            }

            if (notAllRecipientsWereFiltered) {
                setSuccessFormSubmitting(
                    'Your messages were sent successfully!'
                )
                setTimeout(() => {
                    setSuccessFormSubmitting('')
                }, 3000)
                setShow(false)
            }
        } catch (e) {
            setFormErrorSubmitting(e.message)
            setSendingMails(false)
        }
    }

    // Builds and updates the recipientDisplayString, used to show
    // names of recipients in the "To" field
    useEffect(() => {
        const trimCount = sendList.count < 25 ? sendList.length : candidateCount?.length
        const candidates = sendList.slice(0, trimCount)
        let nameList = candidates.reduce(
            (str, candidate, i) =>
                Util.handleUndefinedFullName(candidates[0].first_name, candidates[0].last_name),
            ''
        )
        if (embedded && candidates.length > 0) {
            nameList = Util.handleUndefinedFullName(candidates[0].first_name, candidates[0].last_name)
        }
        setRecipientDisplayString(isEmpty(candidates) ? '' : nameList)
    }, [sendList])

    useEffect(() => {
        if (selectedText.text !== '') {
            setShowAddLinkModal(true)
        }
    }, [selectedText])

    const remCandidate = sendList?.length < 25 ? ' ' :  ( sendList?.length - candidateCount?.length +' '+  "More")
    return (
        <>
            {show ? (
                <div
                    className={`email-client ${
                        embedded ? 'embedded-display' : ''
                    }`}
                >
                    <div className="background-wrap">
                        <div className="modal-header">
                            <h3 className="modal-title">{title}</h3>
                            {!embedded && (
                                <button
                                    aria-label="close-modal"
                                    onClick={handleCloseModal}
                                    className="close-modal-btn"
                                >
                                    <span />
                                </button>
                            )}
                        </div>
                        <div className="modal-body">
                            <div className="body-first-row">
                                <div className="input-block">
                                    <span className="input-title">From</span>
                                    <select
                                        className="regular-input"
                                        onChange={(event) =>
                                            inputChangeHandler(
                                                event,
                                                'fromInput'
                                            )
                                        }
                                    >
                                        <option value={userEmail}>
                                            {userEmail}
                                        </option>
                                    </select>
                                </div>
                                <div className="input-block">
                                    <span className="input-title">To</span>
                                    
                                    <TextareaAutosize
                                        className="regular-input"
                                        placeholder={
                                            isEmpty(recipientDisplayString)
                                                ? '<no candidates selected>'
                                                : recipientDisplayString +' '+ (remCandidate) 
                                        }
                                        disabled={true}
                                        readOnly
                                    />
                                </div>
                                <div className="input-block">
                                    <span className="input-title">Subject</span>
                                    <input
                                        type="text"
                                        value={formState.subjectInput}
                                        ref={subjectRef}
                                        className="regular-input"
                                        onSelect={() =>
                                            setLastUsedVariableInputField(
                                                'subjectInput'
                                            )
                                        }
                                        onChange={(event) =>
                                            inputChangeHandler(
                                                event,
                                                'subjectInput'
                                            )
                                        }
                                    />
                                </div>
                            </div>
                            <div className="body-second-row">
                                <FileUploader
                                    parentId={emailClientId}
                                    onFileSelectSuccess={(file) => {
                                        setUploadedFile(file)
                                    }}
                                    onFileSelectError={({ error }) =>
                                        alert(error)
                                    }
                                />
                                {enableAddLinkButton && (
                                    <button
                                        className="add-link sub-button"
                                        onClick={() => {
                                            var selection = emailContentRef.current.getSelection()
                                            if (
                                                selection == null ||
                                                selection == undefined ||
                                                (selection &&
                                                    selection.length == 0)
                                            ) {
                                                return
                                            }
                                            setShowAddLinkModal(true)
                                            var selectedContent = emailContentRef.current.getContents(
                                                selection.index,
                                                selection.length
                                            )
                                            setSelectedText({
                                                selection,
                                                text:
                                                    selectedContent.ops[0]
                                                        .insert,
                                            })
                                        }}
                                    >
                                        <img
                                            src={AddLinkIcon}
                                            className="sub-button__img"
                                        />
                                        <span>Add Link</span>
                                    </button>
                                )}
                                <Dropdown>
                                    <Dropdown.Toggle className="add-link sub-button">
                                        <img
                                            src={InsertVarIcon}
                                            className="sub-button__img"
                                        />
                                        <span>Insert Variable</span>
                                    </Dropdown.Toggle>
                                    <Dropdown.Menu>
                                        {documentVariables.map((variable) => {
                                            return (
                                                <Dropdown.Item
                                                    key={variable}
                                                    onClick={() =>
                                                        handleInsertVariable(
                                                            variable
                                                        )
                                                    }
                                                >
                                                    {`{{${variable}}}`}
                                                </Dropdown.Item>
                                            )
                                        })}
                                    </Dropdown.Menu>
                                </Dropdown>
                            </div>
                            <div className="body-third-row">
                                <EmailContent
                                    onSelect={() => {
                                        setLastUsedVariableInputField(
                                            'contentTextArea'
                                        )
                                    }}
                                    getQuillRef={(quill) => {
                                        emailContentRef.current = quill
                                    }}
                                    value={formState.contentTextArea}
                                    inputChangeHandler={inputChangeHandler}
                                />
                            </div>
                            <div className="body-fourth-row">
                                {sendingMails && !formErrorSubmitting && (
                                    <span style={{ color: 'black' }}>
                                        Sending emails...
                                    </span>
                                )}
                                <Toast
                                    onClose={() => setFilteredRecipients([])}
                                    show={!isEmpty(filteredRecipients)}
                                >
                                    <Toast.Header>
                                        <strong className="mr-auto">
                                            Note
                                        </strong>
                                    </Toast.Header>
                                    <Toast.Body>
                                        We did not send to the following (
                                        {filteredRecipients.length}) recipients
                                        since they were recently contacted by
                                        your organization:
                                        <textarea
                                            readOnly
                                            style={{
                                                width: '100%',
                                                height: '5rem',
                                                marginTop: '1rem',
                                                color: '#888',
                                            }}
                                            value={filteredRecipients.reduce(
                                                (str, recipient) =>
                                                    str + recipient + '\n',
                                                ''
                                            )}
                                        ></textarea>
                                    </Toast.Body>
                                </Toast>
                                {successFormSubmitting && (
                                    <Alert
                                        style={{ flexGrow: '1' }}
                                        variant="success"
                                        onClose={() =>
                                            setSuccessFormSubmitting(null)
                                        }
                                        dismissible
                                    >
                                        {successFormSubmitting}
                                    </Alert>
                                )}
                                {formErrorSubmitting && (
                                    <Alert
                                        style={{ flexGrow: '1' }}
                                        variant="danger"
                                        onClose={() =>
                                            setFormErrorSubmitting(null)
                                        }
                                        dismissible
                                    >
                                        {formErrorSubmitting}
                                    </Alert>
                                )}
                                {uploadedFile && (
                                    <span className="attached-info">
                                        <img
                                            alt="attached-icon"
                                            src={AttachmentIcon}
                                            className="attached-icon"
                                        />
                                        File 1 Attached
                                        <button
                                            onClick={() =>
                                                setUploadedFile(null)
                                            }
                                            className="delete-attached-btn"
                                        >
                                            &#10005;
                                        </button>
                                    </span>
                                )}
                                {!sendingMails && !embedded && (
                                    <button
                                        onClick={(event) =>
                                            handleSendButton(event)
                                        }
                                        className="submit-modal-btn"
                                    >
                                        <span>Send</span>
                                    </button>
                                )}
                            </div>
                        </div>
                    </div>
                </div>
            ) : (
                <button
                    onClick={handleShowModal}
                    className="toggle-email-client-btn"
                >
                    <span>New Email</span>
                </button>
            )}
            <CreatePasswordPopup
                show={showPasswordModal}
                sendEmail={externalSendEmailFunc}
                closeHandler={() => setShowPasswordModal(false)}
            />
            <AddLinkModal
                initialText={selectedText.text}
                showModal={showAddLinkModal}
                closeModal={() => setShowAddLinkModal(false)}
                getText={(text, link) => {
                    emailContentRef.current.updateContents(
                        new Delta()
                            .retain(selectedText.selection.index)
                            .delete(selectedText.selection.length)
                            .insert(text, {
                                link,
                            })
                    )
                }}
            />
        </>
    )
}

export default EmailClient
