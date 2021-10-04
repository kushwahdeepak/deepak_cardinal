import React, { useRef } from 'react'
import AttachmentIcon from '../../../../assets/images/icons/attachment-icon.svg'
import './styles/EmailClient.scss'

const FileUploader = ({ onFileSelectSuccess, onFileSelectError, parentId }) => {
    const handleFileInput = (e) => {
        const file = e.target.files[0]
        if (file && file.size > 1024 * 1024 * 4)
            onFileSelectError({
                error: 'File size cannot exceed more than 4MB',
            })
        else {
            onFileSelectSuccess(file)
        }
    }

    return (
        <>
            <input
                className="file-uploader__input"
                type="file"
                onChange={handleFileInput}
                id={'file-upload-input_' + parentId}
            />
            <label
                className="add-attachment sub-button"
                htmlFor={'file-upload-input_' + parentId}
                style={{ marginRight: '1rem' }}
            >
                <img src={AttachmentIcon} className="sub-button__img" />
                <span>Add Attachment</span>
            </label>
        </>
    )
}

export default FileUploader
