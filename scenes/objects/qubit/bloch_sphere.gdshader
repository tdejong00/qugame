shader_type spatial;

void fragment() {
    const float LINE_THICKNESS = 0.01;
    const vec3 LINE_COLOR = vec3(0.0, 0.0, 0.0);
    const float LINE_ALPHA = 0.5;

    float interval = (PI / 8.0);

    float longitude_angle = mod(UV.x * 2.0 * PI, interval);
    float latitude_angle = mod(UV.y * PI, interval);

    float longitude = min(longitude_angle, interval - longitude_angle);
    float latitude = min(latitude_angle, interval - latitude_angle);

    if (min(longitude, latitude) < LINE_THICKNESS) {
        ALBEDO = LINE_COLOR;
        ALPHA = LINE_ALPHA;
    } else {
        discard;
    }
}
