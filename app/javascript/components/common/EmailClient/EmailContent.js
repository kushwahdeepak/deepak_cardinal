import React from 'react'
import ReactQuill from 'react-quill'

import './styles/EmailClient.scss'
import 'react-quill/dist/quill.snow.css'

class Editor extends React.Component {
    constructor(props) {
        super(props)
        this.state = { editorHtml: props.value, mountedEditor: false }
        this.quillRef = null
        this.reactQuillRef = null
        this.handleChange = this.handleChange.bind(this)
        this.attachQuillRefs = this.attachQuillRefs.bind(this)
    }

    componentDidMount() {
        this.attachQuillRefs()
    }

    componentDidUpdate() {
        this.attachQuillRefs()
    }

    attachQuillRefs() {
        // Ensure React-Quill reference is available:
        if (typeof this.reactQuillRef.getEditor !== 'function') return
        // Skip if Quill reference is defined:
        if (this.quillRef != null) return

        const quillRef = this.reactQuillRef.getEditor()
        if (quillRef != null) {
            this.quillRef = quillRef
            this.props.getQuillRef(quillRef)
        }
    }

    handleChange(html) {
        this.setState({ editorHtml: html })
        this.props.inputChangeHandler(
            {
                preventDefault: () => {},
                target: {
                    value: html,
                },
            },
            'contentTextArea'
        )
    }

    render() {
        return (
            <div>
                <ReactQuill
                    ref={(el) => {
                        this.reactQuillRef = el
                    }}
                    onChange={this.handleChange}
                    onChangeSelection={this.props.onSelect}
                    defaultValue={this.state.editorHtml}
                    placeholder={this.props.placeholder}
                    readOnly ={this.props.isReadOnly}
                />
            </div>
        )
    }
}

export default Editor
