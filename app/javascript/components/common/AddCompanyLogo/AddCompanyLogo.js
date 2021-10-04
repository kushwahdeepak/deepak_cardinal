import React, { useState, useEffect } from 'react'
import Row from 'react-bootstrap/Row'
import Button from 'react-bootstrap/Button'
import PropTypes from 'prop-types'
import feather from 'feather-icons'

import styles from './styles/AddCompanyLogo.module.scss'

const AddCompanyLogo = ({ getCompanyLogo }) => {
    const [file, setFile] = useState(null)
    const [wrongFileError, setWrongFileError] = useState(null)
    const inputRef = React.createRef()

    useEffect(() => {
        feather.replace()
    })

    const chooseFile = () => {
        inputRef.current.click()
    }

    const handleChange = (e) => {
        if (checkMimeType(e)) {
            setFile(e.target.files[0])
            getCompanyLogo(e.target.files[0])
            setWrongFileError(null)
        }
    }

    const clearFile = () => {
        setFile(null)
        getCompanyLogo(null)
        setWrongFileError(null)
    }

    const checkMimeType = (event) => {
        let file = event.target.files[0]
        let err = ''
        const allowedTypes = ['image/png', 'image/jpeg', 'image/jpg']
        if (allowedTypes.every((type) => file.type !== type)) {
            err += file.type + ' is not a supported format'
        }

        if (err !== '') {
            event.target.value = null
            setWrongFileError(err)
            return false
        }
        return true
    }

    return (
        <>
            <Row className="mx-0 align-items-center">
                <div className='company_logo_label'>
                    <span className={styles.text + ' company_logo_text'}>Company Logo</span>
                </div>
                <div className='company_logo_input'>
                    <Button
                        variant="outline-dark"
                        className={styles.button}
                        onClick={chooseFile}
                    >
                        Choose File
                    </Button>
                    <input
                        className='fileupload'
                        type="file"
                        ref={inputRef}
                        hidden
                        onChange={handleChange}
                    />
                    {file ? (
                        <div>
                            <span className={styles.noFileText}>{file.name}</span>
                            <a className={styles.clearIcon} onClick={clearFile}>
                                <i data-feather="x"></i>
                            </a>
                        </div>
                    ) : wrongFileError ? (
                        <div>
                            <span className={`${styles.noFileText} text-danger`}>
                                {wrongFileError}
                            </span>
                            <a className={styles.clearIcon} onClick={clearFile}>
                                <i data-feather="x"></i>
                            </a>
                        </div>
                    ) : (
                        <span className={styles.noFileText}>No file chosen</span>
                    )}
                </div>
            </Row>
            <Row className="mx-0">
                <p className={styles.text + ' company_logo_heading'}>
                    Please upload a company logo to accompany your job post
                </p>
            </Row>
        </>
    )
}

AddCompanyLogo.propTypes = {
    getCompanyLogo: PropTypes.func.isRequired,
}

export default AddCompanyLogo
