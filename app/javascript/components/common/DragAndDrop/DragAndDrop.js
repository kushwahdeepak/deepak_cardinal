import React, { useRef, useEffect, useState } from 'react'
import Image from 'react-bootstrap/Image'
import Button from 'react-bootstrap/Button'
import PropTypes from 'prop-types'

import styles from './styles/DragAndDrop.module.scss'
import UploadIcon from '../../../../assets/images/talent_page_assets/upload-icon-v4.png'
import folder from '../../../../assets/images/icons/folder.png'

const DragAndDrop = (props) => {
    const dropRef = useRef()
    const fileInputRef = useRef()
    const [dragging, setDragging] = useState(false)
    const { handleFiles, pageName } = props

    let dragCounter

    const fileInputClicked = () => {
        fileInputRef.current.click()
    }

    const filesSelected = () => {
        if (fileInputRef.current.files.length) {
            handleFiles(fileInputRef.current.files)
        }
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
    }, [dropRef])

    return (
        <>
            <div ref={dropRef} className={styles.dropContainer}>
                <input
                    ref={fileInputRef}
                    type="file"
                    onChange={filesSelected}
                    style={{ display: 'none' }}
                />
                {dragging && (
                    <div className={styles.dropArea}>
                        <div className={styles.dropText}>
                            <div>Drop here</div>
                        </div>
                    </div>
                )}
                <div style={{ pointerEvents: 'none' }}>
                    <div className={pageName ? '' : styles.uploadResumeContainer}>
                        <p className={styles.title}>
                            {pageName? '' : 'Upload resume to see matches:'}
                        </p>
                        {pageName && <Image src={folder} className={styles.importJob } /> }
                        <div className="d-flex justify-content-center">
                            {pageName ? '' : <Image src={UploadIcon} style={{ color: '#fff'}} />}
                            <div className="d-flex flex-column align-items-center">
                                <p className={styles.subTitle}>
                                    Drag & drop {pageName ? 'CSV files here' : 'resumes'}
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
                    </div>
                </div>
            </div>
        </>
    )
}

DragAndDrop.propTypes = {
    handleFiles: PropTypes.func.isRequired,
}

export default DragAndDrop
