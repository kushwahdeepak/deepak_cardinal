import React, { useRef } from 'react'
import './styles/CandidateProfilePage.scss'
import styled from 'styled-components'

const Button = styled.button`
    background: linear-gradient(
        94.67deg,
        #4c68ff -1.19%,
        #6077f4 53.94%,
        #8185ff 102.59%
    );
    border-radius: 20px;
    padding: ${(props) => props.tb} ${(props) => props.lr};
    width: fit-content;
    display: flex;
    align-items: center;
`

const W8text = styled.span`
    font-style: normal;
    font-weight: 800;
    color: #ffffff;
    font-size: ${(props) => props.size};
    color: ${(props) => props.color};
    display: flex;
`
const ProfileUploader = (props) => {
    const { onFileSelectSuccess, onFileSelectError, isProfilePicture } = props
    const fileInput = useRef(null)

    const handleFileInput = (e) => {
        const file = e.target.files[0]
        if (file && file.size > 1024 * 1024 * 4)
            onFileSelectError({
                error: 'File size cannot exceed more than 4MB',
            })
        else onFileSelectSuccess(file)
    }

    return (
        <div className="profile-uploader">
            <input
                className="profile-uploader__input"
                type="file"
                accept={
                    isProfilePicture
                        ? 'image/png, image/jpeg'
                        : '.doc,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document, application/pdf, text/plain, .docx,.txt,.pdf'
                }
                onChange={handleFileInput}
            />

                <Button
                    tb="6px"
                    lr="18px"
                    onClick={(e) => {
                        e.preventDefault()
                        fileInput.current && fileInput.current.click()
                    }}
                >
                    <W8text size="10px">
                        Upload New Photo{' '}
                    </W8text>
                </Button>

            
        </div>
    )
}

export default ProfileUploader
