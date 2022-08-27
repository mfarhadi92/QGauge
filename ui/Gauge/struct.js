const Type = {
    CIRCULAR_GTYPE: 0,
    COLORIZE_FILL_GTYPE: 1
};

const ColorizeShapeType = {
    HORIZONTAL_CSHT: 0,
    VERTICAL_CSHT: 1,
    CIRCULAR_CSHT: 2
};

const TextItems = {
    TITLE_TI: 0,
    MEASURE_UNIT_TI: 1,
    DIGIT_VALUE_TI: 2,
    GAUGE_COEF_TI: 3
};

function fn_roundNumber(num) {
    return Math.round(num * 100) / 100
}

