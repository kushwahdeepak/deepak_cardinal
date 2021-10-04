import React, { useRef, useEffect, useState } from 'react'
import styles from './styles/BulkDragDrop.module.scss'
import Image from 'react-bootstrap/Image'
import Button from 'react-bootstrap/Button'
import UploadIcon from '../../../../assets/images/talent_page_assets/upload-icon-v4.png'
import { Row } from 'react-bootstrap'
import feather from 'feather-icons'

function BulkDragDrop(props) {
    const dropRef = useRef()
    const fileInputRef = useRef()
    const [dragging, setDragging] = useState(false)

    const {
        handleFiles,
        title,
        files,
        handleOnRemoveFiles,
        handleOnSubmit,
    } = props

    let dragCounter

    const fileInputClicked = () => {
        fileInputRef.current.click()
    }

    const filesSelected = () => {
        if (fileInputRef.current.files.length) {
            handleFiles(fileInputRef.current.files)
        }
    }
    const handleRemoveResume = (index) => {
        handleOnRemoveFiles(index)
    }

    const handleDrag = (e) => {
        e.preventDefault()
        e.stopPropagation()
    }

    const handleDragIn = (e) => {
        e.preventDefault()
        e.stopPropagation()
        if (e.dataTransfer.items && e.dataTransfer.items.length > 0) {
            setDragging(true)
        }
        dragCounter += 1
    }

    const handleDragOut = (e) => {
        e.preventDefault()
        e.stopPropagation()
        setDragging(false)
        dragCounter -= 1
        if (dragCounter > 0) return
    }

    const handleDrop = (e) => {
        e.preventDefault()
        e.stopPropagation()
        setDragging(false)
        if (e.dataTransfer.files && e.dataTransfer.files.length > 0) {
            handleFiles(e.dataTransfer.files)
            dragCounter = 0
        }
    }
    useEffect(() => {
        feather.replace()
    })

    useEffect(() => {
        dragCounter = 0
        let div = dropRef.current
        div.addEventListener('dragenter', handleDragIn)
        div.addEventListener('dragleave', handleDragOut)
        div.addEventListener('dragover', handleDrag)
        div.addEventListener('drop', handleDrop)

        return () => {
            div.removeEventListener('dragenter', handleDragIn)
            div.removeEventListener('dragleave', handleDragOut)
            div.removeEventListener('dragover', handleDrag)
            div.removeEventListener('drop', handleDrop)
        }
    }, [dropRef, handleFiles])

    return (
        <>
            <Row style={{ margin: '0px', width: '100%' }}>
                <div ref={dropRef} className={styles.dropContainer}>
                    <input
                        ref={fileInputRef}
                        type="file"
                        onChange={filesSelected}
                        style={{ display: 'none' }}
                        multiple
                    />
                    {dragging && (
                        <div className={styles.dropArea}>
                            <div className={styles.dropText}>
                                <div>Drop here</div>
                            </div>
                        </div>
                    )}
                    <div>
                        <div className={styles.uploadResumeContainer}>
                            <div className={styles.flexItem}>
                                <div className="d-flex dragDropItem">
                                    <div>
                                        <Image
                                            src={UploadIcon}
                                            style={{ color: '#fff' }}
                                        />
                                    </div>
                                    <div className="d-flex flex-column align-items-center">
                                        <p className={styles.subTitle}>
                                            Drag & drop {title}
                                        </p>
                                        <p className={styles.orText}>or</p>
                                        <Button
                                            className={styles.button}
                                            onClick={fileInputClicked}
                                            style={{
                                                pointerEvents: dragging
                                                    ? 'unset'
                                                    : 'all',
                                            }}
                                        >
                                            Choose files
                                        </Button>
                                    </div>
                                </div>
                                <div style={{ flex: 1 }}>
                                    <div className={styles.resumeContainer}>
                                        {files.map((resume, index) => (
                                            <div
                                                key={index}
                                                className={styles.resume}
                                            >
                                                <span
                                                    className={
                                                        styles.resumeNameText
                                                    }
                                                >
                                                    {resume.name}
                                                </span>{' '}
                                                <span
                                                    onClick={() =>
                                                        handleRemoveResume(
                                                            index
                                                        )
                                                    }
                                                >
                                                    <i
                                                        data-feather="x"
                                                        size="15px"
                                                        color="#4C68FF"
                                                        className={styles.svgIcon}
                                                    />
                                                </span>
                                            </div>
                                        ))}
                                    </div>
                                </div>
                            </div>

                            <div className={styles.buttonUploadDiv}>
                                <Button
                                    className={styles.buttonUpload}
                                    onClick={handleOnSubmit}
                                >
                                    Upload{' '}
                                </Button>
                            </div>
                        </div>
                    </div>
                </div>
            </Row>
        </>
    )
}

export default BulkDragDrop
