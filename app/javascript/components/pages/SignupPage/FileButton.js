import React, { useEffect, useRef, useState } from 'react'
import styled from 'styled-components'

import Button from './Button'

const Span = styled.span`
    margin-left: 15px;
    font-size: 12px;
    line-height: 16px;
    text-align: center;
    color: ${(props) => (props.close ? 'red' : '#9EA6C8')};
    cursor: ${(props) => (props.close ? 'pointer' : 'auto')};
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
    max-width: 8rem;
    display: inline-block;
`

const FileButton = (props) => {
    const [file, setFile] = useState(props.file)
    const [wrongFileType, setWrongFileType] = useState(props.resumeError)
    const { label, getFile, resumeError, setResumeError, ...rest } = props
    const inputRef = useRef()

    useEffect(() => {
        setWrongFileType(resumeError)
    }, [resumeError])

    const handleClick = (e) => {
        inputRef.current.click()
    }

    const handleFileChange = (e) => {
        if (
            inputRef.current &&
            inputRef.current.files.length &&
            checkFileTypes(inputRef.current.files)
        ) {
            const f = inputRef.current.files[0]
            setWrongFileType(null)
            props.setResumeError(null)
            setFile(f)
            getFile(f)
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
                err +=
                    files[x].type[0].toUpperCase() +
                    files[x].type.slice(1) +
                    ' is not a supported format\n'
            }
        }

        if (err !== '') {
            // if message not same old that mean has error
            setWrongFileType(err)
            setResumeError(err)
            return false
        }
        setWrongFileType(null)
        return true
    }

    return (
        <div>
            <input
                type="file"
                accept=".doc,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document, application/pdf, text/plain, .docx,.txt,.pdf"
                style={{ display: 'none' }}
                ref={inputRef}
                onChange={handleFileChange}
            />
            <Button {...rest} onClick={handleClick}>
                {label}
            </Button>
            <Span>{(file && file.name) || 'No file chosen'}</Span>
            {file && (
                <Span
                    onClick={() => {
                        setFile(null)
                        getFile(null)
                    }}
                    close
                >
                    x
                </Span>
            )}
            {wrongFileType && (
                <p
                    style={{
                        fontSize: '10px',
                        color: 'red',
                        marginTop: '5px',
                    }}
                >
                    {wrongFileType}
                </p>
            )}
        </div>
    )
}

export default FileButton
