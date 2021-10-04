import React, { useState, useEffect } from 'react'
import feather from 'feather-icons'

import Input from '../../common/Styled components/Input'
import moment from 'moment'
import {
    Row,
    W8text,
    InputContainer,
    Container,
    Label,
    DatePicker,
    CheckboxContainer,
    Icon,
} from './styles/CandidateViewProfile.styled'

function EditExperience(props) {
    const {
        experience,
        index,
        dispatch,
        isLastIndex,
        handleExperience,
        handleExperienceDate,
        handleRemoveExperience
    } = props

    const [startDate, setStartDate] = useState(
        `${moment(experience.start_date).format('YYYY')}-${moment(
            experience.start_date
        ).format('MM')}`
    )
    const [endDate, setEndDate] = useState(
        `${moment(experience.end_date).format('YYYY')}-${moment(
            experience.end_date
        ).format('MM')}`
    )
    useEffect(() => {
        feather.replace()
    })

   

    const handleStartDate = (e) => {
       
        handleExperienceDate(`${startDate}-01`, index, 'startDate')
        e.target.type = 'text'
        e.target.value = moment(startDate).format('MM-YYYY')
    }

    const handleEndDate = (e) => {
        
        handleExperienceDate(`${endDate}-01`, index, 'endDate')
        e.target.type = 'text'
        e.target.value = moment(endDate).format('MM-YYYY')
    }

    const handleFocus = (e, date) => {
        e.target.type = 'month'
        e.target.value = moment(date).format('YYYY-MM')
    }

    return (
        <>
            <Container key={experience.id} direction="row">
                <Row direction="row">
                    <InputContainer width="40%" style={{ marginRight: '15px' }}>
                        <Input
                            value={experience.title}
                            label="Postion Title"
                            name="title"
                            onChange={(e) => handleExperience(e, index)}
                            type="text"
                        />
                    </InputContainer>
                    <InputContainer width="40%">
                        <Input
                            value={experience.company_name}
                            label="Company"
                            name="company_name"
                            onChange={(e) => handleExperience(e, index)}
                            type="text"
                        />
                    </InputContainer>
                    <Icon style={{ flexGrow: 1 }}>
                        {/* <i data-feather="trash-2" /> */}
                    </Icon>
                </Row>
                <Row direction="row">
                    <InputContainer width="33%" style={{ marginRight: '10px' }}>
                        <Container direction="row">
                            <Label>Start - End Date</Label>
                        </Container>
                        <Container
                            direction="row"
                            style={{ alignItems: 'center' }}
                        >
                            <DatePicker
                                type="text"
                                onChange={(e) => setStartDate(e.target.value)}
                                placeholder={
                                    startDate != 'Invalid date-Invalid date'
                                        ? moment(startDate).format('MM-YYYY')
                                        : 'MM-YYYY'
                                }
                                onBlur={handleStartDate}
                                onFocus={(e) => handleFocus(e, startDate)}
                            />

                            <W8text
                                size="16px"
                                color="#889BFF"
                                style={{ margin: '0px 8px' }}
                            >
                                -
                            </W8text>

                            <DatePicker
                                type="text"
                                disabled={experience.present ?? true}
                                onChange={(e) => setEndDate(e.target.value)}
                                placeholder={
                                    endDate != 'Invalid date-Invalid date' && experience.present == false
                                        ? moment(endDate).format('MM-YYYY')
                                        : 'MM-YYYY'
                                }
                                min={startDate}
                                onBlur={handleEndDate}
                                onFocus={(e) => handleFocus(e, endDate)}
                            />
                        </Container>
                    </InputContainer>
                    <InputContainer width="40%">
                        <Input
                            value={experience?.location}
                            label="Location"
                            name="location"
                            onChange={(e) => handleExperience(e, index)}
                            type="text"
                        />
                    </InputContainer>
                    <InputContainer width="8%" style={{ display: 'flex' }}>
                        <CheckboxContainer>
                            <input
                                checked={experience?.present}
                                name="present"
                                onChange={() => {
                                    let e = {
                                        target: {
                                            value: !experience?.present,
                                            name: 'present',
                                        },
                                    }
                                    handleExperience(e, index)
                                }}
                                type="checkbox"
                            />
                            <Label style={{ margin: '0px', fontSize: '14px' }}>
                                Present
                            </Label>
                        </CheckboxContainer>
                    </InputContainer>
                </Row>

                <Row direction="row">
                    <InputContainer width="70%">
                        <Input
                            value={experience?.description}
                            label="Description"
                            name="description"
                            onChange={(e) => handleExperience(e, index)}
                            type="textarea"
                            maxLength="500"
                        />
                    </InputContainer>
                    <Icon
                        onClick={() => handleRemoveExperience(experience?.id,index)}
                        style={{ flexGrow: 1 }}
                    >
                        <i data-feather="trash-2" />
                    </Icon>
                </Row>
                {!isLastIndex && (
                    <div
                        style={{
                            width: '100%',
                            height: '2px',
                            background: '#d6d9e8',
                            marginRight: 50,
                            marginBottom: 20,
                        }}
                    />
                )}
            </Container>
        </>
    )
}

export default EditExperience
