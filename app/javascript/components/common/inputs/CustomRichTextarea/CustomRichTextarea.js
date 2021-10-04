import React, { useState, useEffect } from 'react'
import ReactQuill from 'react-quill'
import PropTypes from 'prop-types'

import 'react-quill/dist/quill.snow.css'
import './styles/CustomRichTextarea.scss'

const CustomRichTextarea = ({ handleContentChange, styles, fieldValue }) => {
    useEffect(() => {
        if (fieldValue) {
            setText(fieldValue)
        }
    }, [fieldValue])
    const [text, setText] = useState('')

    const handleChange = (value) => {
        setText(value)
        handleContentChange(value)
    }

    return (
        <>
            <ReactQuill value={text} onChange={handleChange} style={styles} />
        </>
    )
}

CustomRichTextarea.propTypes = {
    handleContentChange: PropTypes.func.isRequired,
    styles: PropTypes.object.isRequired,
}

export default CustomRichTextarea
