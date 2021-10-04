import React, { useRef, useState } from 'react'
import Image from 'react-bootstrap/Image'
import Button from 'react-bootstrap/Button'

import styles from './styles/UploadResumeModal.module.scss'
import ResumeUploadedIcon from '../../../../assets/images/talent_page_assets/upload-icon-v3.png'

const UploadResumeModal = ({
    uploadedResume,
    handleFiles,
    setShowUploadResumeModal,
}) => {
    const fileInputRef = useRef()

    const [fileSelectionFinished, setFileSelectionFinished] = useState(false)
    const [wrongFileType, setWrongFileType] = useState(null)

    const filesSelected = () => {
        if (
            fileInputRef.current &&
            fileInputRef.current.files.length &&
            checkFileTypes(fileInputRef.current.files)
        ) {
            handleFiles(fileInputRef.current.files)
            setFileSelectionFinished(true)

            // Short pause before closing to display success message
            setTimeout(() => {
                setShowUploadResumeModal(false)
            }, 1000)
        }
    }

    const checkFileTypes = (files) => {
        //define message container
        let err = ''
        // list allow mime type
        const types = [
            'application/msword',
            'application/pdf',
            'application/docx',
            'text/plain',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        ]
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
            setWrongFileType(err)
            console.log(err)
            return false
        }
        setWrongFileType(null)
        return true
    }

    return (
        <div className={styles.resumeUploadedModal}>
            <span
                style={{ cursor: 'pointer' }}
                className="ml-auto mr-5"
                onClick={() => setShowUploadResumeModal(false)}
            >
                x
            </span>
            <input
                ref={fileInputRef}
                type="file"
                accept=".doc,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document, application/pdf, text/plain, .docx,.txt,.pdf"
                onChange={filesSelected}
                style={{ display: 'none' }}
            />
            <Image src={ResumeUploadedIcon} />
            <p className={styles.modalText}>
                {fileSelectionFinished
                    ? 'Uploaded successfully!'
                    : uploadedResume
                    ? ''
                    : 'Upload resume'}
            </p>
            {wrongFileType && (
                <p style={{ color: '#ab2537' }}>{wrongFileType}</p>
            )}
            <div className="d-flex justify-content-between align-items-center">
                <Button
                    className={styles.modalButton}
                    onClick={() => fileInputRef.current.click()}
                >
                    Choose File
                </Button>
                <span className={styles.modalSubText}>
                    {uploadedResume
                        ? uploadedResume.name || uploadedResume.filename
                        : 'No file chosen'}
                </span>
            </div>
        </div>
    )
}

export default UploadResumeModal
