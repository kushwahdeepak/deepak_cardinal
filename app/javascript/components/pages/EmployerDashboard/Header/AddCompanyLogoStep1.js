import React, { useState, useEffect } from 'react'
import Row from 'react-bootstrap/Row'
import Button from 'react-bootstrap/Button'
import PropTypes from 'prop-types'
import feather from 'feather-icons'

import styles from '../../../common/AddCompanyLogo/styles/AddCompanyLogo.module.scss'

const AddCompanyLogoStep1 = ({ getCompanyLogo }) => {
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
                <div className='company_logo_input'>
                    <Button
                        className={styles.ml-0}
                        className={styles.mr-0}
                        onClick={chooseFile}
                        style={{marginLeft: '-89px'}}
                    >
                        Upload PNG File
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
                            <span className={styles.noFileTextStep1}>{file.name}</span>
                            <a className={styles.clearIcon} onClick={clearFile}>
                                <i data-feather="x"></i>
                            </a>
                        </div>
                    ) : wrongFileError ? (
                        <div>
                            <span className={`${styles.noFileTextStep1} text-danger`}>
                                {wrongFileError}
                            </span>
                            <a className={styles.clearIcon} onClick={clearFile}>
                                <i data-feather="x"></i>
                            </a>
                        </div>
                    ) : (
                        <span className={styles.noFileTextStep1}>No file chosen</span>
                    )}
                </div>
            </Row>
        </>
    )
}

AddCompanyLogoStep1.propTypes = {
    getCompanyLogo: PropTypes.func.isRequired,
}

export default AddCompanyLogoStep1
