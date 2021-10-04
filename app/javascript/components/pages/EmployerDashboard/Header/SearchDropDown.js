import React from 'react'

function SearchDropDown({
  list,
  selectedItems,
  onChangeOption,
  popupStatus,
  displayBox
}) {
    return(
        <>        
          {list.length > 0 && popupStatus &&
              <ul className='custom-dropdown'>
                  {list.map((e) => {
                  return <li className={`${selectedItems.includes(e) && 'selected'} items-li`} onClick={()=>onChangeOption(e, selectedItems.indexOf(e))}>
                      {e?.city ? `${e.city}, ${e.state} (US)`
                              : e?.company_name ? e.company_name
                              : e.name
                              }
                      </li>
                  })}
              </ul>
          }
          {displayBox && 
            <div className='selected-item-container'>
                <div>
                {
                    Array.isArray(selectedItems) && selectedItems?.map((s, i)=> {
                    return <>
                            <p className="selected-item" 
                                onClick={()=>onChangeOption(s, i)}
                            >
                                {s?.city ? `${s.city}, ${s.state} (US)`
                                : s?.company_name ? s.company_name
                                : s.name
                                }
                                
                                
                                &nbsp;&nbsp; X
                            </p>
                            </>
                    })
                }
                </div>
            </div>
          }
        </>
    )
}
export default SearchDropDown