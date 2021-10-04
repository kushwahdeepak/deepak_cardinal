import React, { useState, useEffect } from 'react'
import styled from 'styled-components'
import Table from 'react-bootstrap/Table'
import Image from 'react-bootstrap/Image'
import { Popover, OverlayTrigger, Dropdown } from 'react-bootstrap'

import P from './P'
import Button from './Button'

import EditIcon from '../../../../../assets/images/icons/pencil-icon-v2.svg'
import DeleteIcon from '../../../../../assets/images/icons/trash-icon-v2.svg'
import XIcon from '../../../../../assets/images/icons/x.svg'
import CheckIcon from '../../../../../assets/images/icons/check.svg'

const THead = styled.div`
    background: #f9f9ff;
    border: 1px solid #e4e9ff;
    box-sizing: border-box;
    width: 100%;

    & div.tr {
        display: flex;
    }

    & div.th {
        padding: 15px 20px;
        border: 1px solid #e4e9ff;
        flex-grow: 0;
        display: flex;
        align-items: center;
        flex-basis: ${(props) => props.size * 100}%;
        max-width: ${(props) => props.size * 100}%;
        overflow-x: hidden;
    }
`

const TRow = styled.div.attrs((props) => ({
    customBorder: props.border || '1px solid #e4e9ff',
}))`
    border-bottom: ${(props) => props.customBorder};
    box-sizing: border-box;
    position: relative;
    display: flex;
    width: ${(props) => (props.edit ? '102%' : '100%')};
    padding-left: ${(props) => (props.edit ? '1%' : 'unset')};
    padding-right: ${(props) => (props.edit ? '1%' : 'unset')};
    background: #ffffff;
    box-shadow: ${(props) =>
        props.edit ? '0px 4px 10px rgba(0, 0, 0, 0.1)' : 'unset'};

    & div.td {
        padding: ${(props) => (props.edit ? '8px 0px' : '10px 20px')};
        border: ${(props) => (props.edit ? 'unset' : '1px solid #e4e9ff')};
        flex-grow: 0;
        display: flex;
        align-items: center;
        flex-basis: ${(props) => props.size * 100}%;
        max-width: ${(props) => props.size * 100}%;
        overflow-x: ${(props) => (props.edit ? 'unset' : 'hidden')};

        a,
        p {
            padding: ${(props) => props.edit && '0px 20px'};
        }
    }
`

const Card = styled(Popover)`
    background: white;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    position: absolute;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 20px;

    & div.arrow {
        display: none;
    }
`

const A = styled.a`
    font-family: Avenir;
    font-style: normal;
    font-weight: normal;
    font-size: 14px;
    line-height: 19px;
    color: #7288ff;
    cursor: pointer;
`

const Input = styled.input`
    background: transparent;
    border-radius: 10px;
    outline: none;
    border: none;
    width: 100%;
    font-family: Avenir;
    font-style: normal;
    font-weight: normal;
    font-size: 14px;
    line-height: 19px;
    color: #3b3847;
    padding: 8px 20px;
    height: 100%;

    &:focus {
        background: #f6f7fc;
    }
`

const CustomDropdown = styled(Dropdown)`
    & div.dropdown-menu {
        background: #ffffff;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
        padding: 0;
        width: 100%;

        & a {
            padding: 10px 20px;
            border-radius: 10px;
        }

        & a:hover {
            background: #f6f7fc;
        }
    }
`

const RolePicker = ({ rowValue, updateAction }) => {
    const CustomToggle = React.forwardRef(({ children, onClick }, ref) => (
        <A
            href=""
            ref={ref}
            onClick={(e) => {
                e.preventDefault()
                onClick(e)
            }}
        >
            {children}
        </A>
    ))

    const handleSelect = (role, e) => {
        updateAction({ ...rowValue, role })
    }

    return (
        <CustomDropdown>
            <CustomDropdown.Toggle
                as={CustomToggle}
                id="dropdown-custom-components"
            >
                {rowValue.role}
            </CustomDropdown.Toggle>

            <CustomDropdown.Menu>
                <CustomDropdown.Item eventKey="1" disabled>
                    Choose Role
                </CustomDropdown.Item>
                <CustomDropdown.Item
                    eventKey="third_party_recruiter"
                    onSelect={handleSelect}
                >
                    Third Party Recruiter
                </CustomDropdown.Item>
                <CustomDropdown.Item
                    eventKey="internal_recruiter"
                    onSelect={handleSelect}
                >
                    Internal Recruiter
                </CustomDropdown.Item>
                <CustomDropdown.Item eventKey="talent" onSelect={handleSelect}>
                    Talent
                </CustomDropdown.Item>
            </CustomDropdown.Menu>
        </CustomDropdown>
    )
}

const xTable = ({
    activePage,
    addNewRow,
    showEditOption,
    saveAction,
    deleteAction,
    columNames = [],
    rowValues = [],
    goToEditPage,
}) => {
    const [action, setAction] = useState(null)
    const [editMode, setEditMode] = useState(addNewRow)

    useEffect(() => {
        setEditMode(addNewRow)
        if (addNewRow) {
            setAction({
                type: 'edit',
                data: rowValues[rowValues.length - 1],
            })
        }
    }, [addNewRow])

    const handleClose = () => {
        setAction(null)
    }
    const handleDelete = () => {
        deleteAction(action.data.id)
        setAction(null)
    }

    const handleSave = (e) => {
        if (e.key === 'Enter') {
            saveAction(action)
            setEditMode(null)
            setAction(null)
        }
    }

    const popover = (
        <Card id="popover-basic">
            <Card.Content>
                <P size="14px" height="19px" center>
                    {showEditOption
                        ? 'Are you sure you want to delete?'
                        : 'Are you sure you want to reject?'}
                </P>
                <div
                    style={{
                        marginTop: '15px',
                        display: 'flex',
                        justifyContent: 'space-around',
                    }}
                >
                    <A onClick={handleDelete}>Yes</A>
                    <A onClick={handleClose} style={{ marginLeft: '60px' }}>
                        No
                    </A>
                </div>
            </Card.Content>
        </Card>
    )

    return (
        <>
            <THead size={1 / columNames.length}>
                <div className="tr">
                    {columNames.map((colData, idx) => (
                        <div className="th" key={idx + colData.name}>
                            <P size="14px" height="19px" color="#3B3847">
                                {colData.name}
                            </P>
                        </div>
                    ))}
                </div>
            </THead>

            {rowValues.map((rowValue, idx) => (
                <TRow
                    size={1 / columNames.length}
                    key={rowValue.id}
                    onKeyPress={handleSave}
                    edit={editMode - 1 == idx}
                >
                    {columNames.map((columData, colIdx) => {
                        if (colIdx == 0) {
                            return (
                                <div
                                    className="td"
                                    key={colIdx + columData.name}
                                    onClick={() => goToEditPage(rowValue.id)}
                                    style={{ cursor: 'pointer' }}
                                >
                                    <P
                                        size="14px"
                                        height="19px"
                                        color="#3B3847"
                                    >
                                        {activePage * 25 + idx + 1}
                                    </P>
                                </div>
                            )
                        }
                        if (columData.field === 'options') {
                            return (
                                <div
                                    className="td"
                                    key={colIdx + columData.name}
                                >
                                    {editMode - 1 == idx ? (
                                        <>
                                            <A
                                                onClick={() => {
                                                    saveAction(action)
                                                    setEditMode(null)
                                                    setAction(null)
                                                }}
                                            >
                                                Save
                                            </A>
                                            <A
                                                onClick={() => {
                                                    setAction(null)
                                                    setEditMode(null)
                                                    if (addNewRow)
                                                        deleteAction(-1)
                                                }}
                                            >
                                                Cancle
                                            </A>
                                        </>
                                    ) : (
                                        <>
                                            {showEditOption ? (
                                                <a
                                                    style={{
                                                        cursor: 'pointer',
                                                    }}
                                                    onClick={() =>
                                                        goToEditPage(
                                                            rowValue.id
                                                        )
                                                    }
                                                >
                                                    <Image src={EditIcon} />
                                                </a>
                                            ) : (
                                                <A
                                                    onClick={() => {
                                                        saveAction({
                                                            data: rowValue,
                                                        })
                                                    }}
                                                >
                                                    <Image src={CheckIcon} />
                                                </A>
                                            )}
                                            <OverlayTrigger
                                                trigger="click"
                                                overlay={popover}
                                                placement="bottom"
                                                show={
                                                    action &&
                                                    action.data.id ===
                                                        rowValue.id
                                                }
                                            >
                                                <A
                                                    onClick={() => {
                                                        setAction({
                                                            type: 'delete',
                                                            data: rowValue,
                                                        })
                                                    }}
                                                    style={{
                                                        marginLeft: '15px',
                                                    }}
                                                >
                                                    <Image
                                                        src={
                                                            showEditOption
                                                                ? DeleteIcon
                                                                : XIcon
                                                        }
                                                    />
                                                </A>
                                            </OverlayTrigger>
                                        </>
                                    )}
                                </div>
                            )
                        }

                        if (columData.field === 'file') {
                            return (
                                <div
                                    className="td"
                                    key={colIdx + columData.name}
                                >
                                    <A
                                        onClick={() => {
                                        }}
                                    >
                                        Download file
                                    </A>
                                </div>
                            )
                        }

                        return editMode &&
                            editMode - 1 == idx &&
                            columData.editable &&
                            columData.type === 'select' ? (
                            <div className="td" key={colIdx + columData.name}>
                                <RolePicker
                                    // rowValue={rowValue}
                                    // updateAction={updateAction}
                                    rowValue={
                                        editMode && action
                                            ? action.data
                                            : rowValue
                                    }
                                    updateAction={(x) => {
                                        setAction({
                                            type: 'edit',
                                            data: {
                                                ...action.data,
                                                [columData.field]: x.role,
                                            },
                                        })
                                    }}
                                />
                            </div>
                        ) : editMode &&
                          editMode - 1 == idx &&
                          columData.editable &&
                          columData.type === 'text' ? (
                            <div className="td" key={colIdx + columData.name}>
                                <Input
                                    type="text"
                                    defaultValue={rowValue[columData.field]}
                                    onChange={(e) =>
                                        // updateAction({
                                        //     ...rowValue,
                                        //     [columData.field]: e.target.value,
                                        // })
                                        setAction({
                                            type: 'edit',
                                            data: {
                                                ...action.data,
                                                [columData.field]:
                                                    e.target.value,
                                            },
                                        })
                                    }
                                />
                            </div>
                        ) : (
                            <div
                                className="td"
                                key={colIdx + columData.name}
                                onClick={() => goToEditPage(rowValue.id)}
                                style={{ cursor: 'pointer' }}
                            >
                                <P size="14px" height="19px" color="#3B3847">
                                    {rowValue[columData.field]}
                                </P>
                            </div>
                        )
                    })}
                </TRow>
            ))}
        </>
    )
}

export default xTable
