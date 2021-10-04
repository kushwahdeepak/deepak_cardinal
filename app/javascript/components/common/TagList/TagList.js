import React from "react";
import styles from "./styles/TagList.module.scss";
import { nanoid } from "nanoid";

function TagList({
  tags = [],
  removeTagFunc,
  maxTags,
  maxTagWidth = "8rem",
  shadows = false,
}) {
  maxTags = maxTags || tags.length

  // remove empty strings
  tags = tags.filter(tag => tag !== "")

  const truncatedCount = tags.length - maxTags
  const truncated = truncatedCount > 0
  const visualTags = tags.slice(0, maxTags)

  const mapTagsList = (tags) => {
    return tags.map((tag) => {
      if (typeof tag === "string") {
        return { id: nanoid(), value: tag };
      }
      return tag;
    });
  };
  
  const handleValue = (value) => { 
    const store = value.split(" ")[0].length > 15
    return store ? value.slice(0,11) + "..." : value
  }
  
  return (
    <>
      {mapTagsList(visualTags).map((tag) => (
        <div
          data-test="tag-item"
          key={tag.id}
          className={"pill-sm" + (shadows ? " shadow-sm " : "") + styles.filterBubble}
        >
          <span className='pill-text' style={{ maxWidth: maxTagWidth, marginRight: '15px', textTransform: "uppercase"}}>
            {handleValue(tag.value)}
          </span>
          {removeTagFunc && (
            <div
            data-test="remove-button"
              onClick={() => removeTagFunc(tag.id)}
              className='pill-close-btn'
              style={{position: 'absolute', float: 'right', bottom: '6px', right: '4px'}}
            >
              <i className='icon-sm' data-feather='x' />
            </div>
          )}
        </div>
      ))}

      {truncated && (
        <div data-test="truncated-block" className={styles.ellipsesPill + " pill"} style={{}}>
          +{truncatedCount} more
        </div>
      )}
    </>
  )
}

export default TagList
