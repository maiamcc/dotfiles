/*
 * Available context bindings:
 *   COLUMNS     List<DataColumn>
 *   ROWS        Iterable<DataRow>
 *   OUT         { append() }
 *   FORMATTER   { format(row, col); formatValue(Object, col); getTypeName(Object, col); isStringLiteral(Object, col); }
 *   TRANSPOSED  Boolean
 * plus ALL_COLUMNS, TABLE, DIALECT
 *
 * where:
 *   DataRow     { rowNumber(); first(); last(); data(): List<Object>; value(column): Object }
 *   DataColumn  { columnNumber(), name() }
 */

// Prints rows like MySQL's \G output: a header line per row, then one
// "column: value" line per column. Column names start at the left edge, and
// spaces after "column:" line the values up one space past the longest name.
// TRANSPOSED is ignored because this format already lists columns vertically.
// NB: written by Claude, not human-verified

NEWLINE = System.getProperty("line.separator")
STARS = "*" * 27
NULL_TEXT = "NULL"

// Returns the column's source table from the JDBC result metadata, or null if unknown.
def tableName(col) {
  def gridColumn = col.respondsTo("getColumn") ? col.getColumn() : null
  def table = gridColumn?.respondsTo("getTable") ? gridColumn.getTable() : null
  return table ?: null
}

// Like the result grid, prefix a column with its table only when another
// selected column has the same name.
def nameCounts = COLUMNS.countBy { it.name() }
def labels = COLUMNS.collect { col ->
  def table = nameCounts[col.name()] > 1 ? tableName(col) : null
  table ? "${table}.${col.name()}" : col.name()
}

def labelWidth = (labels.collect { it.length() }.max() ?: 0) + 2
// Lines after the first in a multi-line value start under the first line's value.
def continuationIndent = " " * labelWidth

def rowCount = 0
ROWS.each { row ->
  rowCount++
  OUT.append("$STARS $rowCount. row $STARS").append(NEWLINE)
  COLUMNS.eachWithIndex { col, i ->
    def value = row.value(col)
    def text = value == null ? NULL_TEXT : FORMATTER.formatValue(value, col)
    def lines = text.split(/\r\n|\r|\n/, -1)
    def label = (labels[i] + ":").padRight(labelWidth)
    OUT.append(lines[0] ? label + lines[0] : label.trim()).append(NEWLINE)
    lines.drop(1).each { line -> OUT.append(line ? continuationIndent + line : "").append(NEWLINE) }
  }
}
