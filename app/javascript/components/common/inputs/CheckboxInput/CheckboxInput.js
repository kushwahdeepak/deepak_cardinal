import React, { useState } from 'react'
import { nanoid } from 'nanoid'
import './styles/CheckboxInput.scss'

const CheckboxInput = (props) => {
    const { customClass, labelText } = props
    const [checkboxState, useCheckboxState] = useState(false)

    const checkboxId = nanoid()

    const checkboxHandler = () => {
        useCheckboxState((prevState) => !prevState)
    }

    return (
        <div className={`recruiting-input-group ${customClass || ''}`}>
            <input
                onChange={checkboxHandler}
                className="recruiting-input-checkbox"
                type="checkbox"
                checked={checkboxState}
                id={checkboxId}
            />
            <label
                className="recruiting-input-label"
                htmlFor="recruiting-checkbox-1"
            >
                {labelText}
            </label>
        </div>
    )
}

export default CheckboxInput
